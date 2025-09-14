# Choice.gd
extends Resource
class_name Choice

@export var text: String = ""
@export var target_path: String = ""

# Visibility / availability
enum FailBehavior { Always, HideIfFail, GreyIfFail }
@export var fail_behavior: int = FailBehavior.HideIfFail

@export var disabled_reason: String = "You can’t do that right now."

@export var show_if: Condition = Condition.new()
@export var enable_if: Condition = Condition.new()


# --- EFFECTS (applied immediately when this choice is selected) ---
# Core stats
@export var delta_mental_health: int = 0
@export var delta_money: int = 0
@export var delta_karma: int = 0

# Flags / inventory (optional – delete if you don’t use them)
@export var add_flags: Array[String] = []
@export var remove_flags: Array[String] = []
@export var add_items: Array[String] = []
@export var remove_items: Array[String] = []

# Optional custom hook on GlobalState: func on_choice_<name>() -> void
@export var on_select_hook: String = ""   # e.g. "on_choice_unlock"
