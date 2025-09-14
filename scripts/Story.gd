extends Control

signal END_OF_STORY
signal END_OF_DAY

@onready var narration_dialog = $"Narration Dialog"
@onready var choices_dialog = $"Choices Dialog"

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


func narrate(beat):
	narration_dialog.visible = true
	narration_dialog.text = beat.text
	narration_dialog.get_node("MarginContainer/VBoxContainer/Advance Button").visible = true


func _on_advance_beat():
	if (current_beat.jumpToNode != ""):
		jumpToNode(current_beat.jumpToNode)
	else:			
		if (current_beat.get_child_count() == 0):
			END_OF_DAY.emit()
		else:
			if (current_beat.choices.size() > 0):
				narration_dialog.get_node("MarginContainer/VBoxContainer/Advance Button").visible = false
				choices_dialog.visible = true
				choices_dialog.choices = current_beat.choices
			else:
				choices_dialog.visible = false
				current_beat = current_beat.get_child(0)
				narrate(current_beat)


func _on_choice_selected(index):
	current_beat = current_beat.get_child(index)
	if current_beat is CheckNode:
		handleCheckNode(current_beat)
	elif current_beat is StoryNode:
		narrate(current_beat)
	else:
		push_error("Tried to go to invalid node type")

func jumpToNode(path):
	current_beat = start_beat.get_node(path)
	narrate(current_beat)

func handleCheckNode(beat):
	var random_float = randf()
	var index = -1
	
	#var paths = beat.paths
	var prob_dist = beat.prob_dist
	var num_items = prob_dist.size()

	var sum = 0
	
	for i in range(num_items):
		sum += prob_dist[i]
		if random_float < prob_dist[i]:
			index = i
			break
			
	jumpToNode(beat.paths[index])
