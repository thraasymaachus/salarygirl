extends Node

signal NEW_DAY

var canStart := false

@onready var title_screen = $"Title Screen"
@onready var story_screen = $"Story Screen"
@onready var game_over_screen = $"Game Over Screen"
@onready var start_message = $"Title Screen/New Game Prompt"
@onready var release = $"Title Screen/Release"


# Called when the node enters the scene tree for the first time.
func _ready():
	title_screen.visible = true
	story_screen.visible = false
	game_over_screen.visible = false
	start_message.visible = false
	release.visible = false
	await get_tree().create_timer(6.0).timeout
	canStart = true
	start_message.visible = true
	release.visible = true

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
	# Display again/quit buttons on end of story splash image


func _on_end_of_day() -> void:
	story_screen.visible = false
	GlobalState.day += 1
	print(GlobalState.day)
	GlobalState.story_flow = load("res://story/day{n}.tscn".format({"n": GlobalState.day}))
	NEW_DAY.emit()
	story_screen.visible = true
	story_screen.startStory()
	
func _on_game_over() -> void:
	story_screen.visible = false
	game_over_screen.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_game_over_screen_restart_story() -> void:
	GlobalState.instantiate_global_variables()
		
	game_over_screen.visible = false
	story_screen.visible = true
	story_screen.startStory()
