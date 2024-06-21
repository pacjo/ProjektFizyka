extends Node

@export var score = 0

func add_score(points):
	score += points
	print("Score: ", score)
