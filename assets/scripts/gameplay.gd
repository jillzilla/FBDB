extends Node

signal blinky;

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

@onready var tween_health_player : Tween = null;
@onready var tween_health_opponent : Tween = null;

@export_category("Data")
@export_file_path("*.json") var stage_1 : String = "";
@export_file_path("*.json") var stage_2 : String = "";
@export_file_path("*.json") var stage_3 : String = "";
@export_file_path("*.json") var stage_4 : String = "";
@export_file_path("*.json") var stage_5 : String = "";

@onready var time_counter : Label = $Control/Top_HUD/Info/Time;
@onready var stage_info : Label = $Control/Top_HUD/Info/Stage;

@onready var buttons_cover : Control = $Control/Bottom_HUD/Buttons_Cover;

@onready var timer_seconds : Timer = $Timer_Seconds;

@onready var player_health_bar : ProgressBar = $Control/Top_HUD/PlayerHealth;
@onready var enemy_health_bar : ProgressBar = $Control/Top_HUD/EnemyHealth;

@onready var question : Label = $Control/QuestionTextContainer/ScrollContainer/Question;

@onready var answer_1 : Button = $Control/Bottom_HUD/Answers_Container/Control/A1;
@onready var answer_2 : Button = $Control/Bottom_HUD/Answers_Container/Control2/A2;
@onready var answer_3 : Button = $Control/Bottom_HUD/Answers_Container/Control3/A3;
@onready var answer_4 : Button = $Control/Bottom_HUD/Answers_Container/Control4/A4;

@onready var timer_flash : Timer = $Timer_Flash;

@onready var lose_screen : Control = $Control/LoseScreen;

@onready var question_text_container : PanelContainer = $Control/QuestionTextContainer;

@onready var scroll_container : ScrollContainer = $Control/QuestionTextContainer/ScrollContainer;

@onready var animation_question_message_box : AnimationPlayer = $Control/QuestionTextContainer/AnimationPlayer;

@onready var opponent : Sprite2D = $Opponent;

@onready var correctsfx : AudioStreamPlayer = $Correct;
@onready var wrongsfx : AudioStreamPlayer = $Wrong;

@onready var background : Sprite2D = $Bg;

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
	
	background.texture = load(data["background"]);
	
	if !AudioManager.music.is_playing():
		AudioManager._play_music(data["stage_theme"]);
	
	opponent.texture = load(data["battle_enemy_sprite"]);
	
	enemy_health_bar.max_value = data["enemy_health"];
	
	if !Global.enemy_health_loaded:
		Global.enemy_health = data["enemy_health"];
		Global.enemy_health_loaded = true;
		
	enemy_health_bar.value = Global.enemy_health;
	
	answer_1.connect("pressed", _on_button_pressed.bind(answer_1));
	answer_2.connect("pressed", _on_button_pressed.bind(answer_2));
	answer_3.connect("pressed", _on_button_pressed.bind(answer_3));
	answer_4.connect("pressed", _on_button_pressed.bind(answer_4));
	
	stage_info.text = "Stage " + str(Global.stage_2_play) + "\n" + data["category"];
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
	
	if player_health > 0 && Global.enemy_health > 0:
		timer_seconds.stop();
	
	if button.text == data["correct_answers"][questions_order[current_question]]: 
		correctsfx.play();
		did_answered_correctly = true;
	else:
		wrongsfx.play();
	
	_blink_effect();
	
	await blinky;
	
	if did_answered_correctly:
		_damage_enemy();
	else:
		_damage_player();
	
	if player_health > 0 && Global.enemy_health > 0:
		_next_question();

func _damage_player() -> void:
	player_health -= 1;
	
	if tween_health_player:
		tween_health_player.kill();
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
			AudioManager._stop_music();
			get_tree().change_scene_to_file("res://assets/scenes/game_over.tscn");

func _damage_enemy() -> void:
	Global.enemy_health -= 1;
	
	if tween_health_opponent:
		tween_health_opponent.kill();
	tween_health_opponent = create_tween();
	
	tween_health_opponent.tween_property(enemy_health_bar,"value",Global.enemy_health,0.5).set_trans(Tween.TRANS_CUBIC);
	
	if Global.enemy_health <= 0:
		Global.enemy_health_loaded = false;
		time_counter.visible = false;
		_destroy_everything();
		Transition._make_sure_it_stops();
		Transition.animation.play("transition");
		await Transition.animation.animation_finished;
		AudioManager._stop_music();
		get_tree().change_scene_to_file("res://assets/scenes/winner.tscn");

func _on_timer_seconds_timeout() -> void:
	if player_health > 0:
		wrongsfx.play();
		_damage_player();
		if player_health <= 0:
			return;
		_next_question();
	elif player_health <= 0:
		lose_screen.queue_free();
		Transition._make_sure_it_stops();
		Transition.animation.play("transition");
		await Transition.animation.animation_finished;
		AudioManager._stop_music();
		get_tree().change_scene_to_file("res://assets/scenes/game_over.tscn");

func _destroy_everything() -> void:
	timer_seconds.stop();
	_button_disappear_effect();

func _on_next_stage_pressed() -> void:
	pass;

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
	
	animation_question_message_box.play("transition");
	
	await animation_question_message_box.animation_finished;
	
	for i in range(answers_group_unshuffled.size()):
		var t1 : Tween = create_tween();
		var t2 : Tween = create_tween();
		
		t1.tween_property(answers_group_unshuffled[i],"scale",Vector2(0.9,0.9),0.5).set_trans(Tween.TRANS_CUBIC);
		t2.tween_property(answers_group_unshuffled[i],"modulate:a",1,0.5).set_trans(Tween.TRANS_CUBIC);
		
		await t1.finished;
		
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

func _blink_effect() -> void:
	var correct_button : Button = null;
	
	for i in range(answers_group_unshuffled.size()):
		if answers_group_unshuffled[i].text == data["correct_answers"][questions_order[current_question]]:
			correct_button = answers_group_unshuffled[i];
			break;
		
	for i in range(8):
		timer_flash.start();
		
		if correct_button.modulate.a != 0:
			correct_button.modulate.a = 0;
		elif correct_button.modulate.a == 0:
			correct_button.modulate.a = 1;
		
		await timer_flash.timeout;

	blinky.emit();