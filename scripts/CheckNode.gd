extends Node

class_name CheckNode

# These aren't used, but might avoid a crash if a CheckNode is interpreted as a StoryNode
@export_multiline var text:String = ""
@export var jumpToNode:String = ""


@export var choices:Array[Choice] = []
# prob_dist is the chance of getting option 1, 2, etc. Must add to 1
@export var prob_dist:Array[float]

@export var eod:bool = false
@export var game_over:bool = false
