extends Control

signal END_OF_STORY
signal GAME_OVER
signal END_OF_DAY
signal RESTART_STORY

@onready var narration_dialog = $"Narration Dialog"
@onready var choices_dialog = $"Choices Dialog"
@onready var status_bar = $"Status Bar"
@onready var quit = $"Quit"
@onready var background = $"Control/Background"

var start_beat
var current_beat

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func startStory():
	start_beat = GlobalState.story_flow.instantiate()
	current_beat = start_beat
	narrate(current_beat)
	choices_dialog.visible = false
	background.visible = true
	status_bar.updateItems(GlobalState.inventory)


func narrate(beat):
	narration_dialog.visible = true
	narration_dialog.text = beat.text
	
	var art: String
	
	var default_art = "default.png"
	var custom_art = beat.beat_art # "something.png"
	var node_art = "{s}.png".format({"s": beat.name}) # "node1.png"

	print("Choices are default ({d}), custom ({c}), and node ({n})".format({"d": default_art, "c": custom_art, "n": node_art}))

	
	# If no art set, use a placeholder
	if (custom_art != ""):
		if ResourceLoader.exists("res://art/beats/{s}".format({"s": custom_art})):
			art = custom_art
		print("chose custom ({s})".format({"s": art}))
	elif ResourceLoader.exists("res://art/beats/{s}".format({"s": node_art})):
		art = node_art
		print("chose node ({s})".format({"s": art}))
	else:
		art = default_art
		print("chose default ({s})".format({"s": art}))
	
	background.texture = load("res://art/beats/{s}".format({"s": art}))
	narration_dialog.get_node("MarginContainer/VBoxContainer/Advance Button").visible = true
	print(GlobalState.inventory)


func _on_advance_beat():
	# Game over
	if (current_beat.game_over):
			GAME_OVER.emit()
	# End of the day
	if (current_beat.eod):
			END_OF_DAY.emit()
	# No choices: move directly on to the next node
	elif (current_beat.jumpToNode != ""): # Check if there's a node that should always immediately follow
		current_beat = start_beat.get_node(current_beat.jumpToNode)
		narrate(current_beat)
	else:
		if (current_beat.choices.size() > 0):
			narration_dialog.get_node("MarginContainer/VBoxContainer/Advance Button").visible = false
			choices_dialog.visible = true
			choices_dialog.choices = current_beat.choices


func _on_choice_selected(choice_index: int) -> void:
	var ch: Choice = current_beat.choices[choice_index]
	GlobalState.apply_choice_effects(ch)
	choices_dialog.visible = false
	
	current_beat = start_beat.get_node(ch.target_path)
	
	# Update Status Bar
	# Items
	status_bar.updateItems(GlobalState.inventory)
	
	# Status
	$"Status Bar/MarginContainer/Stats/MentalHealthLabel".text = "HP: {s}".format({"s": GlobalState.mental_health})
	$"Status Bar/MarginContainer/Stats/MoneyLabel".text = "$: {s}".format({"s": GlobalState.money})
	
	if current_beat is CheckNode:
		handleCheckNode(current_beat)
	elif current_beat is StoryNode:
		narrate(current_beat)

func handleCheckNode(beat):
	# Uses probability to determine which outcome should happen
	var random_float = randf()
	var index = -1
	var prob_dist = beat.prob_dist
	var num_items = prob_dist.size()
	var sum = 0
	for i in range(num_items):
		sum += prob_dist[i]
		if random_float < prob_dist[i]:
			index = i
			break
			
	_on_choice_selected(index)
