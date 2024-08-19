extends Node

const SCORE_REAL_TIMER = 1.8
const SCORE_VISUAL_TIMER = 3
const LEVEL_REAL_TIMER = 15
const LEVEL_VISUAL_TIMER = 20

func _ready():
	$ScoreColorRect/ScoreTimer.start(SCORE_REAL_TIMER)
	
	
func _process(delta):
	# I want the timer to appear to be 3 seconds long, but actually be shorter (LEVEL_START_REAL_TIMER)
	var score_timer_time_left = str(ceil($ScoreColorRect/ScoreTimer.time_left * SCORE_VISUAL_TIMER/SCORE_REAL_TIMER))
	$ScoreColorRect/ScoreTimer/ScoreTimerLabel.text = score_timer_time_left
	
	# Again, want timer to appear to be one value
	var level_timer_time_left = str(ceil($LevelTimer.time_left * LEVEL_VISUAL_TIMER/LEVEL_REAL_TIMER))
	$LevelTimer/LevelTimerLabel.text = level_timer_time_left
	
	var score_text = str(GameManager.p1_score) + " - " + str(GameManager.p2_score)
	$ScoreColorRect/ScoreLabel.text = score_text
	
	
func _on_level_timer_timeout():
	GameManager.next_level(GameManager.TIME_RAN_OUT)


func _on_score_timer_timeout() -> void:
	$ScoreColorRect.set_visible(false)
	$ScoreColorRect/ScoreTimer/ScoreTimerLabel.set_visible(false)
	
	$SpawnPoints/Player1.movement_enabled = true
	$SpawnPoints/Player2.movement_enabled = true
	$LevelTimer/LevelTimerLabel.set_visible(true)
	$LevelTimer.start(LEVEL_REAL_TIMER)
