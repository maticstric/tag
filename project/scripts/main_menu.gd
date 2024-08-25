extends Control

const BOB_SPEED = 0.004
const BOB_AMPLITUDE = 13

@onready var player_button_original_position = $PlayButton.position

func _process(_delta):
	$PlayButton.position.y = player_button_original_position.y + sin(Time.get_ticks_msec() * BOB_SPEED) * BOB_AMPLITUDE

func _on_play_button_pressed():
	GameManager.start_game()
