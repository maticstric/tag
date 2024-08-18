extends Node

const NUM_LEVELS = 2

var curr_level = 1
var all_levels_seen = false

func load_new_level():
	
	GameManager.switch_who_is_it()
	
	if !all_levels_seen:
		get_tree().call_deferred("change_scene_to_file", "res://project/scenes/levels/level" + str(curr_level + 1) + ".tscn")
		
		curr_level += 1
		
		if curr_level == NUM_LEVELS:
			all_levels_seen = true
	else:
		var random_level = randi_range(1, NUM_LEVELS)
		get_tree().call_deferred("change_scene_to_file", "res://project/scenes/levels/level" + str(random_level) + ".tscn")
