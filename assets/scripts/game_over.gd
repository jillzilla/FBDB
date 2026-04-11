extends Node

#functions
func _ready() -> void:
	Global._reset_game_status();

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn");
