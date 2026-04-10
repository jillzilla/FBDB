extends Node

#variables
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn");
