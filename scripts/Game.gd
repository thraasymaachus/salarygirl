extends Node

signal NEW_DAY

var canStart := false

@onready var title_screen = $"Title Screen"
@onready var story_screen = $"Story Screen"
@onready var start_message = $"Title Screen/New Game Prompt"

# Called when the node enters the scene tree for the first time.
func _ready():
	title_screen.visible = true
	story_screen.visible = false
	start_message.visible = false
	await get_tree().create_timer(5.0).timeout
	canStart = true
	start_message.visible = true

# BASE UI NAVIGATION
func _input(event):
	if event is InputEventKey:
		if event.pressed and canStart:
			title_screen.visible = false
			story_screen.visible = true
			
			story_screen.startStory()
			canStart = false

func _on_end_of_story():
	title_screen.visible = true
	story_screen.visible = false


func _on_end_of_day() -> void:
	story_screen.visible = false
	GlobalState.day += 1
	print(GlobalState.day)
	GlobalState.story_flow = load("res://story/day{n}.tscn".format({"n": GlobalState.day}))
	NEW_DAY.emit()
	story_screen.visible = true
	story_screen.startStory()
