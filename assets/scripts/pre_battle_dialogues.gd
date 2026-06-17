extends Node

@export_category("Data")
@export_file_path("*.json") var stage_1: String = "";
@export_file_path("*.json") var stage_2: String = "";
@export_file_path("*.json") var stage_3: String = "";
@export_file_path("*.json") var stage_4: String = "";
@export_file_path("*.json") var stage_5: String = "";

var data: Dictionary = {};

@export var textbox: CanvasLayer;
@export var background: Sprite2D;

@export var diltocutscene: VideoStreamPlayer;

#functions
func _ready() -> void:
	var file: FileAccess = FileAccess.open(Global._get_stage_2_play([stage_1, stage_2, stage_3, stage_4, stage_5]), FileAccess.READ);
	var json_text: String = file.get_as_text();
	
	file.close();
	
	data = JSON.parse_string(json_text);
	
	background.texture = load(data["background"]);
	
	AudioManager._play_music("res://assets/music/Dialogue - Madou Monogatari 1-2-3 (PC-98) OST Track 03.mp3");
	
	Transition._make_sure_it_stops();
	Transition.animation.play_backwards("transition");
	
	await Transition.animation.animation_finished;
	
	match (Global.stage_2_play):
		1:
			textbox._change_char2_texture("d_skeleduende1");
			textbox._show_char_2();
			textbox._queue_text("Skeleduende", "MIMIMIMIMIMIMIMIMIMIMIMIMI");
			
			await textbox.update_graphics;
			
			textbox._change_char1_texture("d_joel3");
			textbox._show_char_1();
			textbox._queue_text("Joel", "A skeleton… WHO’S ALSO A DUENDE?!?!?! BUT– SKELETONS CAN’T BE DUENDES!!! THIS IS BULLSHIT!!!!!!");
			
			await textbox.update_graphics;
			
			textbox._change_char2_texture("d_skeleduende2");
			textbox._queue_text("Skeleduende", "And pineapples don’t belong on pizzas, shithead.");
			
			await textbox.update_graphics;
			
			textbox._change_char2_texture("d_skeleduende1");
			textbox._change_char1_texture("d_joel1");
			textbox._queue_text("Joel", "I’m all over it, to be honest, I think pineapples are kinda okay on pizzas, but you do you, ma–");
			
			await textbox.update_graphics;
			
			textbox._change_char1_texture("d_joel3");
			textbox._queue_text("Joel", "WAAAAAAAITWaitwaitwaitwaitwait… you can TALK?");
		
			await textbox.update_graphics;
		
			textbox._change_char2_texture("d_skeleduende2");
			textbox._queue_text("Skeleduende", "No :)");
				
			await textbox.update_graphics;
			
			textbox._change_char1_texture("d_joel1");
			textbox._queue_text("Joel", "Oh, ok.");
		2:
			textbox._change_char1_texture("d_joel4");
			textbox._show_char_1();
			textbox._queue_text("Joel", "No. Fucking. Way. It’s youuuu! Mr. Bones!! I’ve been a huge fan of you and your games!!!");
			
			await textbox.update_graphics;
			
			textbox._change_char2_texture("d_mrbones2");
			textbox._show_char_2();
			textbox._queue_text("Mr. Bones", "Yeah, man, I get it, but my life isn’t all that sunshine and rainbows, you know… After I had beaten DaGoulian’s regime, I tried looking for a gig, played in a couple of bars, and all that, but maaan…");
			
			await textbox.update_graphics;
		
			textbox._queue_text("Mr. Bones", "I think blues just doesn’t jibe with people anymore. Not to mention, my ghost wife left me, but forget it.");
		
			await textbox.update_graphics;
			
			textbox._change_char1_texture("d_joel2");
			textbox._queue_text("Joel", "Oh man, I feel ya, man. The music biz can be stressy as fuck sometimes…");
			
			await textbox.update_graphics;
			
			textbox._change_char2_texture("d_mrbones1");
			textbox._queue_text("Mr. Bones", "Anyway, there seemed to be an open spot for a job in this tower, so I kinda just jigged my way and got me this gig, it’s chill here, man. Oh yeah, they also gave me a wig. Cool stuff.");
			
			await textbox.update_graphics;
			
			textbox._change_char1_texture("d_joel1");
			textbox._queue_text("Joel", "Hope life finds you good, dude, you gotta do whatever you love to live in life, sorry that happened to ya. Wig looks stupid, but you know.");
			
			await textbox.update_graphics;
			
			textbox._queue_text("Mr. Bones", "Forget it, man. Let’s start this quiz challenge already. I won’t give ya any bones, so don’t cry to yo mama.");
		3:
			textbox._change_char1_texture("d_joel3");
			textbox._show_char_1();
			
			textbox._queue_text("Joel", "What the FUCK are you doing here?! Why are you wearing CARDBOARD on your head??!!");
			
			await textbox.update_graphics;
			
			textbox._change_char2_texture("d_jawbone2");
			textbox._show_char_2();
			
			textbox._queue_text("Jawbone", "Some FUCKERS have put out my hair, I seek revenge, and it will FUCKING start with YOU!!!!!");
			
			await textbox.update_graphics;
			
			textbox._queue_text("", "Fren is whispering something to Joel");
			
			await textbox.update_graphics;
			
			textbox._change_char1_texture("d_joel1");
			
			textbox._queue_text("Joel", "Huh? Fren? What do you say…?");
			
			await textbox.update_graphics;
			
			textbox._change_char1_texture("d_joel3");
			
			textbox._queue_text("Joel", "No I do NOT sound like HIM!!!!!");
			
			await textbox.update_graphics;
			
			textbox._change_char2_texture("d_jawbone1");
			
			textbox._queue_text("Jawbone", "You… sound like ME?! HAH!!! YOU CAN NEVER DREAM OF HAVING THE VOICE OF A FUCKING HUNK LIKE ME!!!! NOW, LET’S GO, BITCH!!!!!!");
		4:
			textbox._change_char2_texture("d_mike2");
			textbox._show_char_2();
			textbox._queue_text("Michael of Jabrongos", "Welcoime, I oim the Heidmoisteir ouf this estoiblishmeint.");
			
			await textbox.update_graphics;
			
			textbox._change_char1_texture("d_joel4");
			textbox._show_char_1();
			textbox._queue_text("Joel", "Couldn’t the Headmaster be BALDER?! HA!!!");
			
			await textbox.update_graphics;
			
			textbox._change_char2_texture("d_mike1");
			textbox._queue_text("Mike", "SHOT OP!!! I OIM NOIT BOLD, YOU FREAK!!!");
			
			await textbox.update_graphics;
			
			textbox._change_char1_texture("d_joel1");
			textbox._queue_text("Joel", "Yes, my friend, yes you are. But thog don’t caaare, you’ll lose your wig anyway after I beat you, and then we’ll see who’s wrong.");
		5:
			textbox._change_char2_texture("d_mike3");
			textbox._show_char_2();
			textbox._queue_text("Mike", "You.. you focked me in the aoiss so good… but... You’ll noiver discouver the whereabouits of tha hoir solu—")
			
			await textbox.update_graphics;
			
			textbox._hide_char_2();
			AudioManager.music.stream_paused = true;
			diltocutscene.play();
			
			await diltocutscene.finished;
			
			diltocutscene.queue_free();
			AudioManager.music.stream_paused = false;
			textbox._change_char2_texture("d_dilto");
			textbox._show_char_2();
			textbox._queue_text("Dilto", "hey you know a place i could park my car with as few people as possible walking around i wanna fuck it later i bet you understand");
			
			await textbox.update_graphics;
			
			textbox._change_char1_texture("d_joel3");
			textbox._show_char_1();
			textbox._queue_text("Joel", "Dilto! You SON OF A BITCH I thought you were dead!!");
			
			await textbox.update_graphics;
			
			textbox._queue_text("Dilto", "yeah i was but i’m better now. anyway i did put a whistle tip inside my cars muffler how did you know i did it for decoration");
			
			await textbox.update_graphics;
			
			textbox._change_char1_texture("d_joel1");
			textbox._queue_text("Joel", "I’m gonna put you down for GOOD this time!! Go back to the shadow, you shall not see the light of day ever again!!");
	
	await textbox.dialogue_finished;
	
	Transition._make_sure_it_stops();
	Transition.animation.play("transition");
	
	await Transition.animation.animation_finished;
	
	AudioManager._stop_music();
	get_tree().change_scene_to_file("res://assets/scenes/vs_screen.tscn");