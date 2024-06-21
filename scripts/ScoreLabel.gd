extends Label

func _ready():
	update_score_label()

func _process(_delta):
	update_score_label()

func update_score_label():
	text = "Score: " + str(ScoreManager.score)
