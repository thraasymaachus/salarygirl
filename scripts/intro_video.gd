extends VideoStreamPlayer

# Export so you can set them in the inspector
@export var first_video: Resource
@export var loop_video: Resource

var switched := false

func _ready() -> void:
	if first_video:
		stream = first_video
		play()
	connect("finished", Callable(self, "_on_video_finished"))

func _on_video_finished() -> void:
	if not switched:
		# First time it finishes: switch to loop video
		if loop_video:
			stream = loop_video
			play()
			loop = true  # Loop from now on
			switched = true
	else:
		# Already switched: just restart the loop video
		play()
