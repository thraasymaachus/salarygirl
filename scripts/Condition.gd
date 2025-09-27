# Condition.gd
extends Resource
class_name Condition

@export var require_all_flags: Array[String] = []   # must ALL be present
@export var require_any_flags: Array[String] = []   # at least one present (optional)
@export var forbid_flags: Array[String]      = []   # must NOT be present

@export var require_all_items: Array[String] = []   # must ALL be present
@export var require_any_items: Array[String] = []   # at least one present (optional)
@export var forbid_items: Array[String]      = []   # must NOT be present

# Simple stat minimums (tweak for your game)
@export var min_mental_health: int = -999999
@export var min_money: int         = -999999
@export var min_karma: int         = -999999

# Optional custom hook: name of a GlobalState method that should return bool
@export var custom_check: String   = ""

func is_met(gs) -> bool:
	# Flags can be Array or Dictionary; handle both.
	var has_flag := func(f):
		if gs.flags is Array:
			return f in gs.flags
		elif gs.flags is Dictionary:
			return gs.flags.get(f, false)
		return false
		
	var has_item := func(f):
		if gs.inventory is Array:
			return f in gs.flags
		elif gs.inventory is Dictionary:
			return gs.inventory.get(f, false)
		return false

	for f in require_all_flags:
		if not has_flag.call(f):
			return false

	if require_any_flags.size() > 0:
		var any_ok := false
		for f in require_any_flags:
			if has_flag.call(f):
				any_ok = true
				break
		if not any_ok:
			return false

	for f in forbid_flags:
		if has_flag.call(f):
			return false

	for f in require_all_items:
		if not has_item.call(f):
			return false

	if require_any_items.size() > 0:
		var any_ok := false
		for f in require_any_items:
			if has_item.call(f):
				any_ok = true
				break
		if not any_ok:
			return false

	for f in forbid_items:
		if has_item.call(f):
			return false

	if gs.mental_health < min_mental_health: return false
	if gs.money         < min_money:         return false
	if gs.karma         < min_karma:         return false

	if custom_check != "" and gs.has_method(custom_check):
		if not gs.call(custom_check):
			return false

	return true
