extends Node

@export var cutscene : VideoStreamPlayer;

func _ready() -> void:
	Transition._make_sure_it_stops();
	Transition.animation.play_backwards("transition");
	
	AudioManager._stop_music();
	cutscene.connect("finished",_is_cutscene_finished);

func _is_cutscene_finished() -> void:
	Transition._make_sure_it_stops();
	Transition.animation.play("transition");
	
	await Transition.animation.animation_finished;
	
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn");
