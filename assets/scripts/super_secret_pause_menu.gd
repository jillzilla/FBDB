extends Control

#functions
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		if ! self.visible:
			self.show();
			get_tree().paused = true;
		else:
			self.hide();
			get_tree().paused = false;