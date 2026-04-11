extends Node

#functions
func _on_play_pressed() -> void:
	Global.credits -= 1;
	GlobalHud._update_credits_counter();
	get_tree().change_scene_to_file("res://assets/scenes/gameplay.tscn");

func _on_quit_pressed() -> void:
	get_tree().quit(0);
