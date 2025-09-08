extends Node


### Basic global variables ###
# Game vars
var day: int = 1

# Player vars
var mental_health: int = 100
var money: int = 30
var karma: int = 0




### Scenes ###
# Load the first scene, updated based on day
var story_flow: PackedScene = preload("res://story/day1.tscn")
