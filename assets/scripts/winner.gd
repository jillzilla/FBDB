extends Node

#variables
@export_category("Data")
@export_file_path("*.json") var stage_1: String = "";
@export_file_path("*.json") var stage_2: String = "";
@export_file_path("*.json") var stage_3: String = "";
@export_file_path("*.json") var stage_4: String = "";
@export_file_path("*.json") var stage_5: String = "";

var data: Dictionary = {};

@onready var background: Sprite2D = $Background;
@onready var button: Button = $Button;

#functions
func _ready() -> void:
	var file: FileAccess = FileAccess.open(Global._get_stage_2_play([stage_1, stage_2, stage_3, stage_4, stage_5]), FileAccess.READ);
	var json_text: String = file.get_as_text();
	data = JSON.parse_string(json_text);
	file.close();
	background.texture = load(data["win_screen"]);
	Transition._make_sure_it_stops();
	Transition.animation.play_backwards("transition");

func _on_button_pressed() -> void:
	button.queue_free();
	Transition._make_sure_it_stops();
	Transition.animation.play("transition");
	await Transition.animation.animation_finished;
	if Global.stage_2_play == 5:
		Global._reset_game_status();
		get_tree().change_scene_to_file("res://assets/scenes/best_end.tscn");
	elif Global.stage_2_play == 4 && Global.credits < 3:
		Global._reset_game_status();
		get_tree().change_scene_to_file("res://assets/scenes/good_end.tscn");
	else:
		Global.stage_2_play += 1;
		AudioManager._stop_music();
		get_tree().change_scene_to_file("res://assets/scenes/pre_battle_dialogues.tscn");