extends Node

#variables
@onready var music: AudioStreamPlayer = $Music;

#functions
func _play_music(path: String) -> void:
	if music.is_playing():
		_stop_music();
	music.stream = load(path);
	music.play();

func _stop_music() -> void:
	music.stop();
	music.stream = null;