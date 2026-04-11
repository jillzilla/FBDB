extends Control

#variables
@export var giveup : Button;
@export var next : Button;

#functions
func _ready() -> void:
	if Global.stage_2_play == 5:
		giveup.queue_free();
		next.text = "The End";

func _on_menu_pressed() -> void:
	Global.stage_2_play = 1;
	Global.credits = 3;
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn");

func _on_next_pressed() -> void:
	Global.stage_2_play += 1;
	if Global.stage_2_play < 5:
		get_tree().reload_current_scene();
	elif Global.stage_2_play >= 5:
		Global.stage_2_play = 1;
		get_tree().quit();
