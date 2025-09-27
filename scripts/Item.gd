extends Resource
class_name Item

@export var name: String = ""
@export_multiline var desc: String = ""
@export var icon: String = ""

# Could be used for the blown up view. Otherwise, just resize icon
@export var fullsizeimage: String = ""

func _init(_name: String = "", _desc: String = "", _icon: String = "", _fullsizeimage: String = ""):
	name = _name
	desc = _desc
	icon = _icon
	fullsizeimage = _fullsizeimage
