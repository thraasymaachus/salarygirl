extends Node

class_name CheckNode

@export_multiline var text:String = "This shouldn't be here"
#@export var choices:Array[String]
# I don't forsee clicking on a checknode choice leading to a change in stats by itself, but I'll keep these here
@export var mental_health:int
@export var money:int
@export var karma:int

# paths contains the different paths to the nodes that could happen
@export var paths:Array[String]
# prob_dist is the chance of getting option 1, 2, etc. Must add to 1
@export var prob_dist:Array[float]
