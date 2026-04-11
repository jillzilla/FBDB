extends CanvasLayer

#variables
@export var credits_counter : Label = null;

#functions
func _update_credits_counter() -> void:
	credits_counter.text = "Credits: " + str(Global.credits);
