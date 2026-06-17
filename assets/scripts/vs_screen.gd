extends Node

#variables
@export_file_path("*.json") var stage_1: String = "";
@export_file_path("*.json") var stage_2: String = "";
@export_file_path("*.json") var stage_3: String = "";
@export_file_path("*.json") var stage_4: String = "";
@export_file_path("*.json") var stage_5: String = "";

@onready var name2text: Label = $Name2;
@onready var opponent: Sprite2D = $Opponent;

var data: Dictionary = {};

#functions
func _ready() -> void:
	AudioManager._play_music("res://assets/music/Versus - Street Fighter Arranged - Versus.mp3");
	var file: FileAccess = FileAccess.open(Global._get_stage_2_play([stage_1, stage_2, stage_3, stage_4, stage_5]), FileAccess.READ);
	var json_text: String = file.get_as_text();
	data = JSON.parse_string(json_text);
	file.close();
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