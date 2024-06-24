extends Control

@onready var start_button = $MainMenuContainer/StartButton
@onready var about_button = $MainMenuContainer/AboutButton
@onready var quit_button = $MainMenuContainer/QuitButton

@onready var music_button = $SettingsMenuContainer/MusicButton
@onready var moon_button = $SettingsMenuContainer/MoonButton

@onready var volume_on_icon = preload("res://assets/volume-high.svg")
@onready var volume_off_icon = preload("res://assets/volume-off.svg")

@onready var moon_mode_on_icon = preload("res://assets/space-station.svg")
@onready var moon_mode_off_icon = preload("res://assets/earth.svg")

func _ready():
	print("Start menu loaded")
	
	start_button.text = "Start Game"
	about_button.text = "About"
	quit_button.text = "Exit"
	
	music_button.texture_normal = volume_off_icon
	moon_button.texture_normal = moon_mode_off_icon

	# Connect buttons to their respective functions
	start_button.pressed.connect(_on_start_button_pressed)
	about_button.pressed.connect(_on_about_button_pressed)
	quit_button.pressed.connect(_on_exit_button_pressed)
	
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
	# toogle "moon mode"
	if GameManager.moon_mode:
		GameManager.moon_mode = false
		Background.texture = preload("res://assets/background_earth.png")
		moon_button.texture_normal = moon_mode_off_icon
	else:
		GameManager.moon_mode = true
		Background.texture = preload("res://assets/background_moon.webp")
		moon_button.texture_normal = moon_mode_on_icon
