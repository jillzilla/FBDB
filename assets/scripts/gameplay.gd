extends Node

#variables
var stage_to_play_path : String = "";

var questions_order : Array[String] = ["q1","q2","q3","q4","q5","q6","q7","q8","q9","q10","q11","q12","q13","q14","q15","q16","q17","q18","q19","q20"];

var current_question : int = 0;
var questions_counter : int = 20;

var data : Dictionary = {};
var answers_group : Array[Button] = [];

var did_answered_correctly : bool = false;

var player_health : int = 100;
var opponent_health : int = 100;

@export_category("Data")
@export_file_path("*.json") var stage_1 : String = "";
@export_file_path("*.json") var stage_2 : String = "";
@export_file_path("*.json") var stage_3 : String = "";
@export_file_path("*.json") var stage_4 : String = "";
@export_file_path("*.json") var stage_5 : String = "";

@export_category("Gameplay Output")
@export var time_counter : Label;
@export var stage_info : Label;

@export var timer_seconds : Timer;

@export var player_health_bar : ProgressBar = null;
@export var enemy_health_bar : ProgressBar = null;

@export var question : Label = null;

@export var answer_1 : Button = null;
@export var answer_2 : Button = null;
@export var answer_3 : Button = null;
@export var answer_4 : Button = null;

#functions
func _ready() -> void:
	match(Global.stage_2_play):
		1:
			stage_to_play_path = stage_1;
		2:
			stage_to_play_path = stage_2;
		3:
			stage_to_play_path = stage_3;
		4:
			stage_to_play_path = stage_4;
		5:
			stage_to_play_path = stage_5;
			
	answers_group = [answer_1,answer_2,answer_3,answer_4];
	
	var file : FileAccess = FileAccess.open(stage_to_play_path, FileAccess.READ);
	var json_text : String = file.get_as_text();
	
	file.close();
	
	data = JSON.parse_string(json_text);
	
	answer_1.connect("pressed", _on_button_pressed.bind(answer_1));
	answer_2.connect("pressed", _on_button_pressed.bind(answer_2));
	answer_3.connect("pressed", _on_button_pressed.bind(answer_3));
	answer_4.connect("pressed", _on_button_pressed.bind(answer_4));
	
	questions_order.shuffle();
	_ask_question();

func _process(_delta: float) -> void:
	time_counter.text = str(int(timer_seconds.time_left));

func _ask_question() -> void:
	stage_info.text = "Stage " + str(Global.stage_2_play) + " - " + str(current_question + 1) + " / " + str(questions_counter);
	
	if player_health > 0:
		timer_seconds.start();
	
	did_answered_correctly = false;
	
	question.text = data["questions"][questions_order[current_question]];
	
	answers_group.shuffle();
	
	for i in range(answers_group.size()):
		answers_group[i].text = data["answers"][questions_order[current_question]][i];
		
func _next_question() -> void:
	current_question += 1;
	
	if current_question < questions_counter:
		_ask_question();
	elif current_question >= questions_counter:
		get_tree().change_scene_to_file("res://assets/scenes/win.tscn");
		
func _on_button_pressed(button: Button) -> void:
	for i in range(answers_group.size()):
		answers_group[i].disabled = true;
	
	if button.text == data["correct_answers"][questions_order[current_question]]: 
		did_answered_correctly = true;
	
	for i in range(answers_group.size()):
		answers_group[i].disabled = false;
	
	if did_answered_correctly:
		opponent_health -= 5;
		enemy_health_bar.value = opponent_health;
	else:
		_damage_player();
	
	if player_health > 0:
		timer_seconds.stop();
		_next_question();

func _damage_player() -> void:
	player_health -= 20;
	player_health_bar.value = player_health;
	
	if player_health <= 0:
		get_tree().change_scene_to_file("res://assets/scenes/game_over.tscn");

func _on_timer_seconds_timeout() -> void:
	_damage_player();
	_next_question();
