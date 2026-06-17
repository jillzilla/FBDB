extends Node

#variables
var stage_2_play : int = 1;
var credits : int = 4;

var enemy_health : int = 0;
var enemy_health_loaded : bool = false;

var fullscreen : bool = false;

#functions
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Fullscreen"):
		if !fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN);
			fullscreen = true;
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
			fullscreen = false;

func _reset_game_status() -> void:
	stage_2_play = 1;
	credits = 4;
	enemy_health_loaded = false;
	GlobalHud._update_credits_counter();