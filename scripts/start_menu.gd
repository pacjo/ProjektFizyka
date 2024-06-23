extends Control

@onready var music_button = $SettingsMenuContainer/MusicButton
@onready var moon_button = $SettingsMenuContainer/MoonButton

@onready var volume_on_icon = preload("res://assets/volume-high.svg")
@onready var volume_off_icon = preload("res://assets/volume-off.svg")

func _ready():
	print("Start menu loaded")
	
	$MainMenuContainer/StartButton.text = "Start Game"
	$MainMenuContainer/AboutButton.text = "About"
	$MainMenuContainer/QuitButton.text = "Exit"
	
	music_button.texture_normal = volume_off_icon
	moon_button.texture_normal = preload("res://assets/space-station.svg")

	# Connect buttons to their respective functions
	$MainMenuContainer/StartButton.pressed.connect(_on_start_button_pressed)
	$MainMenuContainer/AboutButton.pressed.connect(_on_about_button_pressed)
	$MainMenuContainer/QuitButton.pressed.connect(_on_exit_button_pressed)
	
	music_button.pressed.connect(_on_music_button_pressed)
	moon_button.pressed.connect(_on_moon_button_pressed)

func _process(_delta):
	# TODO: fix exiting when AboutDialog is open
	if Input.is_action_pressed("pause"):
		get_tree().quit()		# TODO: change to pause

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_about_button_pressed():
	$AboutDialog.popup_centered()

func _on_exit_button_pressed():
	get_tree().quit()

func _on_music_button_pressed():
	if BackgroundMusic.playing:
		BackgroundMusic.stop()
		music_button.texture_normal = volume_off_icon
	else:
		BackgroundMusic.play()
		music_button.texture_normal = volume_on_icon

func _on_moon_button_pressed():
	# enable "moon mode"
	# TODO: do the same as we did with music icon
	print("MOON MODE!!")
