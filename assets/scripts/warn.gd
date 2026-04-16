extends Node

func _on_button_pressed() -> void:
	$Control/Button.queue_free();
	
	Transition._make_sure_it_stops();
	Transition.animation.play("transition");
	
	await Transition.animation.animation_finished;
	
	get_tree().change_scene_to_file("res://assets/scenes/intro.tscn");
