extends Node

const LEVEL_TIMER = 30 # in secs

var current_it


func switch_who_is_it():
	if current_it == 1:
		current_it = 2
	else:
		current_it = 1
	
	
func start_game():
	current_it = randi_range(1, 2)
	LevelManager.load_new_level()
