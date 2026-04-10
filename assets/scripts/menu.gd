extends Node

#functions
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/stage_select.tscn");

func _on_quit_pressed() -> void:
	get_tree().quit(0);
