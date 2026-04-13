extends Node

#variables
@export var name2text : Label;

@export_file_path("*.json") var stage_1 : String = "";
@export_file_path("*.json") var stage_2 : String = "";
@export_file_path("*.json") var stage_3 : String = "";
@export_file_path("*.json") var stage_4 : String = "";
@export_file_path("*.json") var stage_5 : String = "";

@export var opponent : Sprite2D;

var stage_to_play_path : String = "";

var data : Dictionary = {};

#functions
func _ready() -> void:
	AudioManager._play_music("res://assets/music/Versus - Street Fighter Arranged - Versus.mp3");
	
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
	
	opponent.texture = load(data["battle_enemy_sprite"]);
	
	name2text.text = data["enemy_name"];
	
	Transition._make_sure_it_stops();
	Transition.animation.play_backwards("transition");

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "whole_anim":
		Transition._make_sure_it_stops();
		Transition.animation.play("transition");
		await Transition.animation.animation_finished;
		AudioManager._stop_music();
		get_tree().change_scene_to_file("res://assets/scenes/gameplay.tscn");
