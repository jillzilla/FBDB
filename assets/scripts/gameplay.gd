extends Node

#variables
var stage_to_play_path : String = "";

var questions_order : Array[String] = ["q1","q2","q3","q4","q5","q6","q7","q8","q9","q10","q11","q12","q13","q14","q15","q16","q17","q18","q19","q20"];

var current_question : int = 0;
var questions_counter : int = 20;

var data : Dictionary = {};
var answers_group : Array[Button] = [];
var answers_group_unshuffled : Array[Button] = [];

var did_answered_correctly : bool = false;

var player_health : int = 4;

var did_win : bool = false;

@onready var tween_health_player : Tween = null;
@onready var tween_health_opponent : Tween = null;

@export_category("Data")
@export_file_path("*.json") var stage_1 : String = "";
@export_file_path("*.json") var stage_2 : String = "";
@export_file_path("*.json") var stage_3 : String = "";
@export_file_path("*.json") var stage_4 : String = "";
@export_file_path("*.json") var stage_5 : String = "";

@export_category("Gameplay Output")
@export var time_counter : Label;
@export var stage_info : Label;

@export var buttons_cover : Control;

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

@export var scroll_container : ScrollContainer = null;
@export var next_scene_button : Button;

@export var animation_question_message_box : AnimationPlayer = null;

#functions
func _ready() -> void:
	answers_group = [answer_1,answer_2,answer_3,answer_4];
	answers_group_unshuffled = [answer_1,answer_2,answer_3,answer_4];
	
	Transition._make_sure_it_stops();
	Transition.animation.play_backwards("transition");
	
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
	if time_counter.text != str(int(timer_seconds.time_left)):
		time_counter.text = str(int(timer_seconds.time_left));

func _ask_question() -> void:
	scroll_container.scroll_vertical = 0;
	did_answered_correctly = false;
	question.text = data["questions"][questions_order[current_question]];
	answers_group.shuffle();
	
	for i in range(answers_group.size()):
		answers_group[i].text = data["answers"][questions_order[current_question]][i];
	_button_appear_effect();
		
func _next_question() -> void:
	current_question += 1;
	
	if current_question < questions_counter:
		_ask_question();
	elif current_question >= questions_counter:
		current_question = 0;
		questions_order.shuffle();
		_ask_question();
		
func _on_button_pressed(button: Button) -> void:
	buttons_cover.visible = true;
	
	if button.text == data["correct_answers"][questions_order[current_question]]: 
		did_answered_correctly = true;
	
	if did_answered_correctly:
		_damage_enemy();
	else:
		_damage_player();
	
	if player_health > 0 && Global.enemy_health > 0:
		timer_seconds.stop();
		_next_question();

func _damage_player() -> void:
	player_health -= 1;
	
	if tween_health_player:
		tween_health_player = null;
	tween_health_player = create_tween();
	
	tween_health_player.tween_property(player_health_bar,"value",player_health,0.5).set_trans(Tween.TRANS_CUBIC);
	
	if player_health <= 0:
		_destroy_everything();
		await animation_question_message_box.animation_finished;
		if Global.credits > 0:
			timer_seconds.start();
			lose_screen.visible = true;
		elif Global.credits <= 0:
			Transition._make_sure_it_stops();
			Transition.animation.play("transition");
			await Transition.animation.animation_finished;
			get_tree().change_scene_to_file("res://assets/scenes/game_over.tscn");

func _damage_enemy() -> void:
	Global.enemy_health -= 1;
	
	if tween_health_opponent:
		tween_health_opponent = null;
	tween_health_opponent = create_tween();
	
	tween_health_opponent.tween_property(enemy_health_bar,"value",Global.enemy_health,0.5).set_trans(Tween.TRANS_CUBIC);
	
	if Global.enemy_health <= 0:
		Global.enemy_health_loaded = false;
		time_counter.visible = false;
		_destroy_everything();
		did_win = true;
		hint_next_stage.visible = true;
		next_scene_button.visible = true;

func _on_timer_seconds_timeout() -> void:
	if player_health > 0:
		_damage_player();
		if player_health <= 0:
			return;
		_next_question();
	elif player_health <= 0:
		lose_screen.queue_free();
		Transition._make_sure_it_stops();
		Transition.animation.play("transition");
		await Transition.animation.animation_finished;
		get_tree().change_scene_to_file("res://assets/scenes/game_over.tscn");

func _destroy_everything() -> void:
	timer_seconds.stop();
	_button_disappear_effect();

func _on_next_stage_pressed() -> void:
	next_scene_button.visible = false;
	
	Transition._make_sure_it_stops();
	Transition.animation.play("transition");
	await Transition.animation.animation_finished;
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

func _button_appear_effect() -> void:
	answer_1.disabled = true;
	answer_2.disabled = true;
	answer_3.disabled = true;
	answer_4.disabled = true;
	
	answer_1.modulate.a = 0;
	answer_2.modulate.a = 0;
	answer_3.modulate.a = 0;
	answer_4.modulate.a = 0;
	
	answer_1.scale = Vector2(0.5,0.5);
	answer_2.scale = Vector2(0.5,0.5);
	answer_3.scale = Vector2(0.5,0.5);
	answer_4.scale = Vector2(0.5,0.5);
	
	var t1 : Tween = null;
	var t2 : Tween = null;
	
	animation_question_message_box.play("transition");
	
	await animation_question_message_box.animation_finished;
	
	for i in range(answers_group_unshuffled.size()):
		if t1:
			t1 = null;
		if t2:
			t2 = null;
			
		t1 = create_tween();
		t2 = create_tween();
		
		t1.tween_property(answers_group_unshuffled[i],"scale",Vector2(0.9,0.9),0.5).set_trans(Tween.TRANS_CUBIC);
		t2.tween_property(answers_group_unshuffled[i],"modulate:a",1,0.5).set_trans(Tween.TRANS_CUBIC);
		
		await t1.finished;
		await t2.finished;
		
	answer_1.disabled = false;
	answer_2.disabled = false;
	answer_3.disabled = false;
	answer_4.disabled = false;
	
	timer_seconds.start();
	
	buttons_cover.visible = false;

func _button_disappear_effect() -> void:
	answer_1.disabled = true;
	answer_2.disabled = true;
	answer_3.disabled = true;
	answer_4.disabled = true;
	
	answer_1.modulate.a = 1;
	answer_2.modulate.a = 1;
	answer_3.modulate.a = 1;
	answer_4.modulate.a = 1;
	
	answer_1.scale = Vector2(0.9,0.9);
	answer_2.scale = Vector2(0.9,0.9);
	answer_3.scale = Vector2(0.9,0.9);
	answer_4.scale = Vector2(0.9,0.9);
	
	animation_question_message_box.play_backwards("transition");
	
	for i in range(answers_group_unshuffled.size()):
		var t1 : Tween = create_tween();
		var t2 : Tween = create_tween();
		
		t1.tween_property(answers_group_unshuffled[i],"scale",Vector2(0.5,0.5),0.5).set_trans(Tween.TRANS_CUBIC);
		t2.tween_property(answers_group_unshuffled[i],"modulate:a",0,0.5).set_trans(Tween.TRANS_CUBIC);
