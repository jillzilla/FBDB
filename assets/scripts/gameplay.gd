extends Node

#variables
var stage_to_play_path : String = "";

var questions_order : Array[String] = ["q1","q2","q3","q4","q5","q6","q7","q8","q9","q10","q11","q12","q13","q14","q15","q16","q17","q18","q19","q20"];

var current_question : int = 0;
var questions_counter : int = 20;

var data : Dictionary = {};
var answers_group : Array[Button] = [];

var did_answered_correctly : bool = false;

var player_health : int = 5;

var did_win : bool = false;

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

@export var lose_screen : Control = null;

@export var question_text_container : PanelContainer;

@export var hint_next_stage : Label;

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
	
	enemy_health_bar.max_value = data["enemy_health"];
	if !Global.enemy_health_loaded:
		Global.enemy_health = data["enemy_health"];
		Global.enemy_health_loaded = true;
	enemy_health_bar.value = Global.enemy_health;
	
	answer_1.connect("pressed", _on_button_pressed.bind(answer_1));
	answer_2.connect("pressed", _on_button_pressed.bind(answer_2));
	answer_3.connect("pressed", _on_button_pressed.bind(answer_3));
	answer_4.connect("pressed", _on_button_pressed.bind(answer_4));
	
	stage_info.text = "Stage " + str(Global.stage_2_play);
	questions_order.shuffle();
	_ask_question();

func _process(_delta: float) -> void:
	time_counter.text = str(int(timer_seconds.time_left));
	
	if Input.is_action_just_pressed("NextStage") && did_win:
		if Global.stage_2_play == 5:
			print("Best Ending")
			Global._reset_game_status();
			get_tree().quit(0);
		elif Global.stage_2_play == 4 && Global.credits < 3:
			print("Normal Ending")
			Global._reset_game_status();
			get_tree().quit(1);
		else:
			get_tree().reload_current_scene();
		
		Global.stage_2_play += 1;

func _ask_question() -> void:
	if player_health > 0 && Global.enemy_health > 0:
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
		current_question = 0;
		questions_order.shuffle();
		_ask_question();
		
func _on_button_pressed(button: Button) -> void:
	for i in range(answers_group.size()):
		answers_group[i].disabled = true;
	
	if button.text == data["correct_answers"][questions_order[current_question]]: 
		did_answered_correctly = true;
	
	for i in range(answers_group.size()):
		answers_group[i].disabled = false;
	
	if did_answered_correctly:
		_damage_enemy();
	else:
		_damage_player();
	
	if player_health > 0 && Global.enemy_health > 0:
		timer_seconds.stop();
		_next_question();

func _damage_player() -> void:
	player_health -= 1;
	player_health_bar.value = player_health;
	
	if player_health <= 0:
		_destroy_everything();
		if Global.credits > 0:
			timer_seconds.start();
		else:
			time_counter.visible = false;
		lose_screen.visible = true;

func _damage_enemy() -> void:
	Global.enemy_health -= 1;
	enemy_health_bar.value = Global.enemy_health;
	
	if Global.enemy_health <= 0:
		Global.enemy_health_loaded = false;
		time_counter.visible = false;
		_destroy_everything();
		did_win = true;
		hint_next_stage.visible = true;

func _on_timer_seconds_timeout() -> void:
	if player_health > 0:
		_damage_player();
		_next_question();
	elif player_health <= 0:
		lose_screen.next_button.queue_free();

func _destroy_everything() -> void:
	question_text_container.visible = false;
	
	timer_seconds.stop();
	
	answer_1.queue_free();
	answer_2.queue_free();
	answer_3.queue_free();
	answer_4.queue_free();
	question.queue_free();
