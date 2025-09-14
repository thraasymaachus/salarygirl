# ChoiceDialogue.gd
extends PanelContainer

signal SELECTED(index)   # Emits the ORIGINAL index in the StoryNode.choices array

@onready var choices_list := $"MarginContainer/Choices"
@onready var choice_prefab := $"MarginContainer/Choices/Choice Button"

# We now accept Array[Choice] instead of Array[String]
var choices: Array[Choice] = []:
	set(value):
		choices = value
		_init_buttons()

# Tracks which original choice index each visible button represents
var _visible_to_choice_index: Array[int] = []

func _ready():
	pass

func _init_buttons() -> void:
	# Clear existing dynamic buttons (keep element 0 as a prefab to reuse)
	for i in range(choices_list.get_child_count() - 1, 0, -1):
		var btn := choices_list.get_child(i)
		btn.queue_free()

	# Also reset and disconnect the first (prefab) button
	var first_btn: Button = choices_list.get_child(0)
	if first_btn.pressed.is_connected(_on_button_pressed_stub):
		first_btn.pressed.disconnect(_on_button_pressed_stub)
	first_btn.visible = false
	first_btn.disabled = false
	first_btn.tooltip_text = ""
	first_btn.text = ""

	_visible_to_choice_index.clear()

	var added := 0
	for i in choices.size():
		var ch: Choice = choices[i]

		# ---- Visibility / enable rules ----
		var show_ok := ch.show_if == null or ch.show_if.is_met(GlobalState)
		var enable_ok := ch.enable_if == null or ch.enable_if.is_met(GlobalState)

		if not show_ok and ch.fail_behavior == Choice.FailBehavior.HideIfFail:
			continue  # hidden entirely

		# Create or reuse a button for this visible choice
		var b: Button
		if added == 0:
			b = first_btn
		else:
			b = choice_prefab.duplicate() as Button
			choices_list.add_child(b)

		b.visible = true
		b.text = ch.text
		b.disabled = not enable_ok
		if not enable_ok and ch.disabled_reason != "":
			b.tooltip_text = ch.disabled_reason
		else:
			b.tooltip_text = ""


		# Reconnect cleanly
		if b.pressed.is_connected(_on_button_pressed_stub):
			b.pressed.disconnect(_on_button_pressed_stub)
		# Bind the ORIGINAL index i
		b.pressed.connect(_on_button_pressed_stub.bind(i))

		_visible_to_choice_index.append(i)
		added += 1

	# If nothing to show, hide the whole panel
	visible = added > 0

func _on_button_pressed_stub(original_index: int) -> void:
	# If the choice is disabled, do nothing (could play a buzz sound or flash)
	var which_btn := _button_for_original_index(original_index)
	if which_btn and which_btn.disabled:
		return
	visible = false
	SELECTED.emit(original_index)

func _button_for_original_index(original_index: int) -> Button:
	# Find the button that maps to this original index
	# first button is child(0) if present; after that, children are in order added
	for child_idx in range(choices_list.get_child_count()):
		var btn := choices_list.get_child(child_idx)
		if not (btn is Button):
			continue
		# Rebuild mapping by walking visible_to_choice_index order:
		# child(0) corresponds to first visible choice, child(1) to second, etc.
		var visible_slot := child_idx  # because we kept non-buttons out of this container
		if visible_slot < _visible_to_choice_index.size() and _visible_to_choice_index[visible_slot] == original_index:
			return btn
	return null
