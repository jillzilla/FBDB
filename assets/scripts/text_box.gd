extends CanvasLayer

signal text_end;
signal dialogue_finished;
signal update_graphics;

#variables
const CHAR_READ_RATE : float = 0.03;

@export var whole_thing : Control;

@export var name_container : MarginContainer;

@export var name_dialogue : Label;
@export var text_dialogue : Label;

@export var character_1 : TextureRect;
@export var character_2 : TextureRect;

@onready var tween : Tween = null;

@export var strt : AudioStreamPlayer;

@export var five_big_booms : AudioStreamPlayer;

enum States
{
	READY,
	READING,
	FINISHED,
}

var current_state : Variant = States.READY;

var name_queue : Array[String] = [];
var text_queue : Array[String] = [];

@export var timer : Timer;

#functions
func _ready() -> void:
	text_end.connect(_text_ended);
	_hide_textbox();

func _show_char_1() -> void:
	character_1.visible = true;

func _hide_char_1() -> void:
	character_1.visible = false;
	
func _change_char1_texture(spr_name: String) -> void:
	character_1.texture = load("res://assets/images/dialogue_sprites/" + spr_name + ".png");

func _change_char2_texture(spr_name: String) -> void:
	character_2.texture = load("res://assets/images/dialogue_sprites/" + spr_name + ".png");

func _show_char_2() -> void:
	character_2.visible = true;
	
func _hide_char_2() -> void:
	character_2.visible = false;
	
func _hide_textbox() -> void:
	whole_thing.visible = false;
	text_dialogue.text = "";

func _process(_delta: float) -> void:
	match(current_state):
		States.READY:
			if !text_queue.is_empty():
				_display_text();
			else:
				dialogue_finished.emit();
				_hide_textbox();
		States.READING:
			if Input.is_action_just_pressed("ProgressDialogue"):
				text_dialogue.visible_ratio = 1;
				tween.stop();
				_change_state(States.FINISHED);
				timer.stop();
		States.FINISHED:
			if Input.is_action_just_pressed("ProgressDialogue"):
				_change_state(States.READY);
				update_graphics.emit();
				strt.play()

func _show_textbox() -> void:
	whole_thing.visible = true;

func _queue_text(n: String, t: String) -> void:
	name_queue.push_back(n);
	text_queue.push_back(t);

func _display_text() -> void:
	var n : String = name_queue.pop_front();
	var t : String = text_queue.pop_front();
	
	if n != "":
		name_dialogue.text = n;
		name_container.visible = true;
	else:
		name_container.visible = false;
		
	text_dialogue.text = t;
	text_dialogue.visible_ratio = 0;
	
	_show_textbox();
	
	_change_state(States.READING);
	
	if tween:
		tween = null;
	tween = create_tween();
	
	timer.start();
	tween.tween_property(text_dialogue,"visible_ratio", 1, len(t) * CHAR_READ_RATE);
	
	await tween.finished;
	
	text_end.emit();

func _text_ended() -> void:
	_change_state(States.FINISHED);
	timer.stop();

func _change_state(next_state : Variant) -> void:
	current_state = next_state;

func _on_timer_timeout() -> void:
	five_big_booms.play();
