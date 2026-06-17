extends Node

#variables
@export var cutscene: VideoStreamPlayer;

#functions
func _ready() -> void:
	Transition._make_sure_it_stops();
	Transition.animation.play_backwards("transition");
	
	AudioManager._stop_music();
	cutscene.connect("finished", _is_cutscene_finished);

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_cutscenes"):
		if !cutscene.paused:
			cutscene.paused = true;
		else:
			cutscene.paused = false;
	if Input.is_action_just_pressed("skip_scenes"):
		get_tree().change_scene_to_file("res://assets/scenes/menu.tscn");

func _is_cutscene_finished() -> void:
	Transition._make_sure_it_stops();
	Transition.animation.play("transition");
	await Transition.animation.animation_finished;
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn");