extends Node

@export var button : Button;

#functions
func _ready() -> void:
	Transition._make_sure_it_stops();
	Transition.animation.play_backwards("transition");
	Global._reset_game_status();

func _on_timer_timeout() -> void:
	button.queue_free();
	Transition._make_sure_it_stops();
	Transition.animation.play("transition");
	await Transition.animation.animation_finished;
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn");

func _on_button_pressed() -> void:
	button.queue_free();
	Transition._make_sure_it_stops();
	Transition.animation.play("transition");
	await Transition.animation.animation_finished;
	get_tree().change_scene_to_file("res://assets/scenes/menu.tscn");
