extends Node

@export var textbox : CanvasLayer;

#functions
func _ready() -> void:
	AudioManager._play_music("res://assets/music/Dialogue - Madou Monogatari 1-2-3 (PC-98) OST Track 03.mp3");
	
	Transition._make_sure_it_stops();
	Transition.animation.play_backwards("transition");
	
	await Transition.animation.animation_finished;
	
	match(Global.stage_2_play):
		1:
			textbox._queue_text("","Int. Day. Inside Tower\nIn the first floor, Joel and Fren encounter the duende, who is also a skeleton, and a wizard")
			textbox._queue_text("Skeleduende","MIMIMIMIMIMIMIMIMIMIMIMIMI");
			textbox._queue_text("Joel","A skeleton… WHO’S ALSO A DUENDE?!?!?! BUT– SKELETONS CAN’T BE DUENDES!!! THIS IS BULLSHIT!!!!!!");
			textbox._queue_text("Skeleduende","And pineapples don’t belong on pizzas, shithead.");
			textbox._queue_text("Joel","I’m all over it, to be honest, I think pineapples are kinda okay on pizzas, but you do you, ma–");
			textbox._queue_text("Joel","WAAAAAAAITWaitwaitwaitwaitwait… you can TALK?");
			textbox._queue_text("Skeleduende","No :)");
			textbox._queue_text("Joel","Oh, ok.");
		2:
			textbox._queue_text("","Int. Day. Second floor of tower\nJoel and Fren, beating the duende, go up to the second floor")
			textbox._queue_text("Joel","No. Fucking. Way. It’s youuuu! Mr. Bones!! I’ve been a huge fan of you and your games!!!");
			textbox._queue_text("Mr. Bones","Yeah, man, I get it, but my life isn’t all that sunshine and rainbows, you know… After I had beaten DaGoulian’s regime, I tried looking for a gig, played in a couple of bars, and all that, but maaan…");
			textbox._queue_text("Mr. Bones"," I think blues just doesn’t jibe with people anymore. Not to mention, my ghost wife left me, but forget it.");
			textbox._queue_text("Joel","Oh man, I feel ya, man. The music biz can be stressy as fuck sometimes…");
			textbox._queue_text("Mr. Bones","Anyway, there seemed to be an open spot for a job in this tower, so I kinda just jigged my way and got me this gig, it’s chill here, man. Oh yeah, they also gave me a wig. Cool stuff.");
			textbox._queue_text("Joel"," hope life finds you good, dude, you gotta do whatever you love to live in life, sorry that happened to ya. Wig looks stupid, but you know.");
			textbox._queue_text("Mr. Bones","Forget it, man. Let’s start this quiz challenge already. I won’t give ya any bones, so don’t cry to yo mama.");
		3:
			textbox._queue_text("","Int. Day. Third floor of tower\nJoel and Fren enter the third floor, Jawbone is waiting for them")
			textbox._queue_text("Joel","What the FUCK are you doing here?! Why are you wearing CARDBOARD on your head??!!");
			textbox._queue_text("Jawbone","Some FUCKERS have put out my hair, I seek revenge, and it will FUCKING start with YOU!!!!!");
			textbox._queue_text("","Fren is whispering something to Joel");
			textbox._queue_text("Joel","Huh? Fren? What do you say…? No I do NOT sound like HIM!!!!!");
			textbox._queue_text("Jawbone","You… sound like ME?! HAH!!! YOU CAN NEVER DREAM OF HAVING THE VOICE OF A FUCKING HUNK LIKE ME!!!! NOW, LET’S GO, BITCH!!!!!!");
		4:
			textbox._queue_text("","Int. Day. Fourth floor of tower\nJoel and Fren go up to the fourth floor, the man they must face reveals himself")
			textbox._queue_text("Michael of Jabrongos","Welcoime, I oim the Heidmoisteir ouf this estoiblishmeint.");
			textbox._queue_text("Joel","Couldn’t the Headmaster be BALDER?! HA!!!");
			textbox._queue_text("Mike","SHOT OP!!! I OIM NOIT BOLD, YOU FREAK!!!");
			textbox._queue_text("Joel","Yes, my friend, yes you are. But thog don’t caaare, you’ll lose your wig anyway after I beat you, and then we’ll see who’s wrong.");
		5:
			textbox._queue_text("Mike","You.. you focked me in the aoiss so good… but... You’ll noiver discouver the whereabouits of tha hoir solu—")
			textbox._queue_text("","A CAR COMES AND HITS MIKE, SENDING HIM OFF THE TOWER");
			textbox._queue_text("","Dilto Kirkland leaves the car...");
			textbox._queue_text("Dilto","hey you know a place i could park my car with as few people as possible walking around i wanna fuck it later i bet you understand");
			textbox._queue_text("Joel","Dilto! You SON OF A BITCH I thought you were dead!!");
			textbox._queue_text("Dilto","yeah i was but i’m better now. anyway i did put a whistle tip inside my cars muffler how did you know i did it for decoration");
			textbox._queue_text("Joel","I’m gonna put you down for GOOD this time!! Go back to the shadow, you shall not see the light of day ever again!!");
	
	await textbox.dialogue_finished;
	
	Transition._make_sure_it_stops();
	Transition.animation.play("transition");
	
	await Transition.animation.animation_finished;
	
	AudioManager._stop_music();
	get_tree().change_scene_to_file("res://assets/scenes/vs_screen.tscn");
