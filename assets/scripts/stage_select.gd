extends Node

#variables
@export var stage_1_button : Button = null;
@export var stage_2_button : Button = null;
@export var stage_3_button : Button = null;
@export var stage_4_button : Button = null;
@export var stage_5_button : Button = null;

#functions
func _ready() -> void:
	stage_1_button.connect("pressed", _on_button_pressed.bind(stage_1_button));
	stage_2_button.connect("pressed", _on_button_pressed.bind(stage_2_button));
	stage_3_button.connect("pressed", _on_button_pressed.bind(stage_3_button));
	stage_4_button.connect("pressed", _on_button_pressed.bind(stage_4_button));
	stage_5_button.connect("pressed", _on_button_pressed.bind(stage_5_button));

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn");

func _on_button_pressed(button: Button) -> void:
	match(button.text):
		"Stage 1":
			Global.stage_2_play = 1;
		"Stage 2":
			Global.stage_2_play = 2;
		"Stage 3":
			Global.stage_2_play = 3;
		"Stage 4":
			Global.stage_2_play = 4;
		"Stage 5":
			Global.stage_2_play = 5;
			
	get_tree().change_scene_to_file("res://assets/scenes/gameplay.tscn");
