extends Control

signal RESTART_STORY

func _on_again_pressed() -> void:

	RESTART_STORY.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()
