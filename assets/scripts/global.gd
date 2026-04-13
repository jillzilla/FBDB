extends Node

#variables
var stage_2_play : int = 1;
var credits : int = 4;

var enemy_health : int = 0;
var enemy_health_loaded : bool = false;

#functions
func _reset_game_status() -> void:
	stage_2_play = 1;
	credits = 4;
	enemy_health_loaded = false;
	GlobalHud._update_credits_counter();
