# Status System

A data-driven buff/debuff system for the industrial auto-battler. Every persistent gameplay effect — employee bonuses, event modifiers, combat rewards — is a `Status` instance attached to the `Player`.

---

## 1. Core Files

| File | Role |
|---|---|
| `Status.gd` | Base class. Lifecycle, duration, signal wiring. `RefCounted`. |
| `StatModifier.gd` | Declarative stat contribution. `Resource`. |
| `Player.gd` | Owns `active_status[]`. Applies, queries, computes stats. |
| `EmployeeDefinition.gd` | `.tres` data. `build() -> Status`. |
| `EventDefinition.gd` | `.tres` data. `build() -> Array[Status]` (0..N). |
| `BricklayerStatus.gd` | Example of a conditional, permanent status. |
| `EventBus` (autoload) | Global signal hub. |

A concrete Status is a **subclass** of `Status.gd`. Definitions are **`.tres` files** whose `build()` maps `id → subclass`.

---

## 2. Lifecycle

```
PENDING ──activate()──▶ ACTIVE ──expire()──▶ EXPIRED
                          │
                          └──▶ APPLIED   (optional, one-shots)
```

`activate()` is idempotent (early-returns unless `PENDING`). Statuses are **single-use** — build a fresh one per application, never reuse.

---

## 3. Call Flow

### Applying

```
HiringScreen   ──▶ Player.apply_status(employee_def.build())
EventScreen    ──▶ Player.apply_status(e) for e in event_def.build()
BattleResolver ──▶ Player.apply_status(reward_status)
```

`Player.apply_status` is the **only entry point**. It:

1. Rejects null / non-`PENDING`.
2. Rejects duplicates when `stack_policy == REJECT` and `has_status(definition_id)`.
3. Appends to `active_status`.
4. Calls `e.activate(self)`.

Inside `activate()`:

```gdscript
_on_activate()        # subclass: connect behavior signals, flip flags, one-shots
_connect_duration()   # base: connect lifetime signals per `duration`
```

### During the run

- Signals fire via `EventBus` (e.g. `battle_won`, `stage_ended`). Subclasses react — mutating internal flags (`_earned_bonus = true`) or calling `expire()`.
- `Player.get_stat_breakdown(attr)` is the **single reader**. It iterates `active_status`, calls `get_modifiers()`, aggregates.

### Expiring

```gdscript
state = EXPIRED
_disconnect_duration()         # base
_disconnect_other_signals()    # subclass
player.active_status.erase(self)
_on_expire()                   # subclass
```

Everything connected in `_on_activate()` **must** be disconnected in `_disconnect_other_signals()`.

### Reading stats

```gdscript
var b := player.get_stat_breakdown(Player.LABOR)
# b.final == max(0, (base + Σflat) * (1 + Σpct))
```

Never mutate `base_stats` outside a Status's `_on_activate()` for irreversible one-shots (e.g. `Mad Scientist`).

---

## 4. Architecture Decisions

**`StatModifier` is `Resource`, `Status` is `RefCounted`.** Modifier is pure data (inspectable, serializable). Status has no per-frame behavior and lives outside the scene tree; `Node` would pay scene-tree overhead for nothing. `RefCounted` gives automatic destruction — see §5 for the signal consequence.

**`Array[Status]`, not `Dictionary`.** `has_status(def_id)` is O(n) either way — the ID isn't the key. With ~20 statuses, `Array.append` + `erase(self)` is simpler, no ID bookkeeping. Don't switch without profiling evidence.

**Additive stacking.** All `PERCENT` modifiers sum: `final = (base + Σflat) * (1 + Σpct)`. No order-dependent multiplication — predictable and no runaway stacking.

**`StackPolicy` per-class, enforced by `Player`.** `REJECT`/`STACK` is behavior, so it lives on the subclass (`_init()`). Enforcement lives in `apply_status()`. UI never enforces it.

**Definition → Status via `build()`.** Centralizes `id → subclass`. UI calls `build()` and hands the result to `apply_status()`. `definition_id` is set on the instance so `has_status("bricklayer")` works.

**Conditional effects in `get_modifiers()`.** A status that grants a bonus only after X holds an internal flag toggled by a signal handler; `get_modifiers()` returns `[]` until set. No re-application, no Player mutation. See `BricklayerStatus`.

---

## 5. Signal Management (Godot-specific)

`EventBus` is an **autoload** — it lives for the whole process. Any signal connection it holds keeps the `Callable` alive.

`Status` is `RefCounted`, so **Godot does not auto-disconnect signals on collection**. A `Node` gets `_exit_tree()` for free; a `RefCounted` does not. Consequences:

- A `Status` connected to `EventBus.battle_won` without disconnecting is **never freed** → leak + callbacks on an expired object.
- Every connection from `_on_activate()` / `_connect_duration()` must be undone in the matching `_disconnect_*`.
- Always guard with `is_connected(callable)` before disconnecting.
- `Player` should iterate `active_status` in its own teardown (e.g. `_exit_tree`) and force-expire each, so `PERMANENT` statuses still disconnect at end of run.

---

## 6. Adding a New Status

1. `my_status.gd` extends `Status`.
2. `_init()`: set `display_name`, `stack_policy`, `duration` (+ `duration_value` for `N_MAP_TURNS`).
3. Override `get_modifiers()` — return fresh `StatModifier` instances (don't cache).
4. Behavior events: connect in `_on_activate()`, disconnect in `_disconnect_other_signals()`.
5. Expiry side effects: override `_on_expire()`.
6. Register `id → MyStatus.new()` in the relevant `build()`.

---

## 7. Known Gotchas

- **`StatModifier.display_name` is read in `get_stat_breakdown()` but not declared on `StatModifier`.** Add `@export var display_name: String`, or read `status.display_name` instead. Current code fails on the breakdown path.
- **`_disconnect_duration()` ignores `duration`** and checks all three signals unconditionally. Harmless, but not symmetric with `_connect_duration()`.
- **`BattleController` is assumed to apply rewards via `Player.apply_status()`.** Keep it that way — UI screens must not diverge into custom reward logic.