extends Node

#functions
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/gameplay.tscn");

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn");
