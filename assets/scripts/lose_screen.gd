extends Control

#variables
@onready var next: Button = $Panel/Buttons/Control/Next;
@export var timer_seconds: Timer = null;

#functions
func _on_next_pressed() -> void:
	next.queue_free();
	timer_seconds.stop();
	Transition._make_sure_it_stops();
	Transition.animation.play("transition");
	await Transition.animation.animation_finished;
	Global.credits -= 1;
	GlobalHud._update_credits_counter();
	get_tree().reload_current_scene();