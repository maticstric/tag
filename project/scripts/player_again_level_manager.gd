extends Node

func _ready():
	var winner = "1" if GameManager.p1_score == GameManager.MAX_SCORE else "2"
	
	$SpawnPoints/Player1.movement_enabled = true
	$SpawnPoints/Player2.movement_enabled = true
	$SpawnPoints/Player1/ITLabel.visible = false
	$SpawnPoints/Player2/ITLabel.visible = false
	
	if winner == "1":
		$SpawnPoints/Player1.MOVE_SPEED *= 2
		$SpawnPoints/Player2.MOVE_SPEED /= 2
	else:
		$SpawnPoints/Player1.MOVE_SPEED /= 2
		$SpawnPoints/Player2.MOVE_SPEED *= 2
	
	$PlayerWonLabel.text = "PLAYER " + winner + " WON!"
	
	$ScoreLabel.text = str(GameManager.p1_score) + " - " + str(GameManager.p2_score)
