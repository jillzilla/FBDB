extends Control

#functions
func _on_next_pressed() -> void:
	Global.credits -= 1;
	GlobalHud._update_credits_counter();
	get_tree().reload_current_scene();
