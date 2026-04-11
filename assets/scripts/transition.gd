extends CanvasLayer

#variables
@export var animation : AnimationPlayer = null;

#functions
func _make_sure_it_stops() -> void:
	if animation.is_playing():
		animation.stop();
