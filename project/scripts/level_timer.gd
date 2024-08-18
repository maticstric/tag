extends Timer

func _ready():
	#wait_time = GameManager.LEVEL_TIMER
	start(GameManager.LEVEL_TIMER)
	
func _process(delta):
	$TimerLabel.text = str(ceil(time_left))
	
	
func _on_timeout():
	LevelManager.load_new_level()
