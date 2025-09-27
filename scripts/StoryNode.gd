extends Node

class_name StoryNode

@export_multiline var text:String
@export var choices:Array[Choice] = []
@export var jumpToNode:String
@export var eod:bool = false
@export var game_over:bool = false

@export var beat_art:String
