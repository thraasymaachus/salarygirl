extends Label

var color_list: Array[Color] = [Color.WHITE, Color.YELLOW, Color.CYAN, Color.MAGENTA]
var cycle_speed: float = 2.0
var time_elapsed: float = 0.0

func _process(delta):
	time_elapsed += delta
	
	# Calculate the color index based on elapsed time and speed
	var current_index = int(floor(time_elapsed * cycle_speed)) % color_list.size()
	var next_index = (current_index + 1) % color_list.size()
	
	# Get the two colors to interpolate between
	var start_color = color_list[current_index]
	var end_color = color_list[next_index]
	
	# Calculate the interpolation factor
	var lerp_factor = fmod(time_elapsed * cycle_speed, 1.0)
	
	# Set the new color using linear interpolation (lerp)
	modulate = start_color.lerp(end_color, lerp_factor)
