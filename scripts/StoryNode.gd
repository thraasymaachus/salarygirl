extends Node

class_name StoryNode

@export_multiline var text:String
@export var choices:Array[Choice] = []
@export var jumpToNode:String
@export var eod:bool = false
@export var game_over:bool = false

# If unspecified, it will try to use "res://art/beats/<nodename>.png". If that doesn't exist, it will use the default image
@export var beat_art:String = ""
