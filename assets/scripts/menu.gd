extends Node

#variables
@export var start : AudioStreamPlayer;

@export var play_button : Button = null;
@export var settings_button : Button = null;
@export var credits_button : Button = null;
@export var quit_button : Button = null;

#functions
func _ready() -> void:
	Transition._make_sure_it_stops();
	Transition.animation.play_backwards("transition");

func _on_play_pressed() -> void:
	start.play();
	play_button.queue_free();
	settings_button.queue_free();
	quit_button.queue_free();
	credits_button.queue_free();
	Transition._make_sure_it_stops();
	Transition.animation.play("transition");
	await Transition.animation.animation_finished;
	Global.credits -= 1;
	GlobalHud._update_credits_counter();
	get_tree().change_scene_to_file("res://assets/scenes/pre_battle_dialogues.tscn");

func _on_quit_pressed() -> void:
	get_tree().quit(0);

func _on_credits_pressed() -> void:
	$credits.show();
