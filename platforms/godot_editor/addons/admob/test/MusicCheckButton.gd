extends CheckButton

func _ready():
	$Music.playing = pressed

func _on_MusicCheckButton_pressed():
	$Music.playing = pressed
