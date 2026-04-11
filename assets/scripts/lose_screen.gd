extends Control

#variables
@export var next_button : Button = null;
@export var credits_counter : Label = null;

#functions
func _ready() -> void:
	credits_counter.text = "Credits: " + str(Global.credits);
	
	if Global.credits <= 0:
		next_button.queue_free();

func _on_menu_pressed() -> void:
	Global.stage_2_play = 1;
	Global.credits = 3;
	print("Bad Ending");
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn");

func _on_next_pressed() -> void:
	Global.credits -= 1;
	get_tree().reload_current_scene();
