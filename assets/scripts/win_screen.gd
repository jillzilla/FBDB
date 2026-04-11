extends Control

#variables
@export var giveup : Button;
@export var next : Button;

#functions
func _ready() -> void:
	if Global.stage_2_play == 5 && Global.credits >= 3 || Global.stage_2_play == 4 && Global.credits < 3:
		giveup.queue_free();
		next.text = "The End";

func _on_menu_pressed() -> void:
	Global.stage_2_play = 1;
	Global.credits = 3;
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn");

func _on_next_pressed() -> void:
	Global.stage_2_play += 1;
	if next.text != "The End":
		get_tree().reload_current_scene();
	else:
		if Global.stage_2_play == 5 && Global.credits >= 3:
			print("Best Ending")
			get_tree().quit(0);
		elif Global.stage_2_play == 4 && Global.credits < 3:
			print("Normal Ending")
			get_tree().quit(1);
