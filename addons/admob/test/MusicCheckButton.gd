extends CheckButton

func _ready():
	$Music.playing = button_pressed

func _on_MusicCheckButton_pressed():
	$Music.playing = button_pressed
