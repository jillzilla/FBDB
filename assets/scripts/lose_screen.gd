extends Control

#variables
@export var next_button : Button = null;

#functions
func _ready() -> void:
	if Global.credits <= 0:
		next_button.queue_free();

func _on_menu_pressed() -> void:
	Global._reset_game_status();
	print("Bad Ending");
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn");

func _on_next_pressed() -> void:
	Global.credits -= 1;
	GlobalHud._update_credits_counter();
	get_tree().reload_current_scene();
