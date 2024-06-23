extends Node

func _ready():
	print("Main scene loaded")

func _process(_delta):
	if Input.is_action_pressed("pause"):
		get_tree().quit()		# TODO: change to pause
