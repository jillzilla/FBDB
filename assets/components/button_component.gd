extends Node
class_name ButtonComponent

#variables
@export var button : Button;
@onready var tween : Tween = null;

@export var scale_min : float;
@export var scale_max : float;
@export var speed : float;

#functions
func _ready() -> void:
	button.connect("mouse_entered",_on_button_mouse_entered);
	button.connect("mouse_exited",_on_button_mouse_exited);

func _on_button_mouse_entered() -> void:
	if !button.disabled:
		if tween:
			tween = null;
		tween = create_tween();
		tween.tween_property(button,"scale",Vector2(scale_max,scale_max),speed).set_trans(Tween.TRANS_CUBIC);
	
func _on_button_mouse_exited() -> void:
	if !button.disabled:
		if tween:
			tween = null;
		tween = create_tween();
		tween.tween_property(button,"scale",Vector2(scale_min,scale_min),speed).set_trans(Tween.TRANS_CUBIC);
