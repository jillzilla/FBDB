extends Node

#variables
var data : Dictionary = {};
var stage_to_play_path : String = "";

@export_category("Data")
@export_file_path("*.json") var stage_1 : String = "";
@export_file_path("*.json") var stage_2 : String = "";
@export_file_path("*.json") var stage_3 : String = "";
@export_file_path("*.json") var stage_4 : String = "";
@export_file_path("*.json") var stage_5 : String = "";

#functions
func _ready() -> void:
	match(Global.stage_2_play):
		1:
			stage_to_play_path = stage_1;
		2:
			stage_to_play_path = stage_2;
		3:
			stage_to_play_path = stage_3;
		4:
			stage_to_play_path = stage_4;
		5:
			stage_to_play_path = stage_5;
	
	var file : FileAccess = FileAccess.open(stage_to_play_path, FileAccess.READ);
	var json_text : String = file.get_as_text();
	
	file.close();
	
	data = JSON.parse_string(json_text);
	
	$Background.texture = load(data["win_screen"]);
	
	Transition._make_sure_it_stops();
	Transition.animation.play_backwards("transition");

func _on_button_pressed() -> void:
	$Button.queue_free();
	
	Transition._make_sure_it_stops();
	Transition.animation.play("transition");
	
	await Transition.animation.animation_finished;
	
	if Global.stage_2_play == 5:
		print("Best Ending")
		Global._reset_game_status();
		get_tree().change_scene_to_file("res://assets/scenes/best_end.tscn");
	elif Global.stage_2_play == 4 && Global.credits < 3:
		print("Normal Ending")
		Global._reset_game_status();
		get_tree().change_scene_to_file("res://assets/scenes/good_end.tscn");
	else:
		AudioManager._stop_music();
		get_tree().change_scene_to_file("res://assets/scenes/pre_battle_dialogues.tscn");
	
	Global.stage_2_play += 1;
