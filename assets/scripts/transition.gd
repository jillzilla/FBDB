extends CanvasLayer

#variables
@onready var animation: AnimationPlayer = $Animations;

#functions
func _make_sure_it_stops() -> void:
	if animation.is_playing():
		animation.stop();