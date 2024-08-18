extends Node

var player_scene

func _ready():
	player_scene = load("res://project/scenes/player.tscn")
	spawn_players()
	
	
func spawn_players():
	
	var player1 = player_scene.instantiate()
	player1.name = str("Player1")
	player1.player_num = 1
	
	
	var player2 = player_scene.instantiate()
	player2.name = str("Player2")
	player2.player_num = 2
	
	if GameManager.current_it == 1:
		player1.is_it = true
	else:
		player2.is_it = true
	
	add_child(player1)
	player1.global_position = get_child(0).global_position
	
	add_child(player2)
	player2.global_position = get_child(1).global_position
