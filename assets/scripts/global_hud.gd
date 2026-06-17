extends CanvasLayer

#variables
@onready var credits_counter: Label = $Credits_Counter;

#functions
func _update_credits_counter() -> void:
	credits_counter.text = "Credits: " + str(Global.credits);