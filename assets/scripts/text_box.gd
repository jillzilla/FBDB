extends CanvasLayer

signal text_end;

#variables
const CHAR_READ_RATE : float = 0.03;

@export var whole_thing : Control;

@export var text_dialogue : Label;

@onready var tween : Tween = null;

enum States
{
	READY,
	READING,
	FINISHED,
}

var current_state : Variant = States.READY;
var text_queue : Array[String] = [];

#functions
func _ready() -> void:
	text_end.connect(_text_ended);
	_hide_textbox();
	
	_queue_text("Joel: Test Test Test. It's working, it's actually working!")

func _hide_textbox() -> void:
	whole_thing.visible = false;
	text_dialogue.text = "";

func _process(_delta: float) -> void:
	match(current_state):
		States.READY:
			if !text_queue.is_empty():
				_display_text();
		States.READING:
			if Input.is_action_just_pressed("NextStage"):
				text_dialogue.visible_ratio = 1;
				tween.stop();
				_change_state(States.FINISHED);
		States.FINISHED:
			if Input.is_action_just_pressed("NextStage"):
				_change_state(States.READY);
				_hide_textbox();

func _show_textbox() -> void:
	whole_thing.visible = true;

func _queue_text(t: String) -> void:
	text_queue.push_back(t);

func _display_text() -> void:
	var t : String = text_queue.pop_front();

	if tween:
		tween = null;
	tween = create_tween();
	
	text_dialogue.text = t;
	text_dialogue.visible_ratio = 0;
	
	_change_state(States.READING);
	_show_textbox();
	
	tween.tween_property(text_dialogue,"visible_ratio", 1, len(t) * CHAR_READ_RATE);
	await tween.finished;
	
	text_end.emit();

func _text_ended() -> void:
	_change_state(States.FINISHED);

func _change_state(next_state : Variant) -> void:
	current_state = next_state;
