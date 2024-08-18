extends Node

var curr_level = 1
var all_levels_seen = false

@onready var num_levels = DirAccess.open("res://project/scenes/levels/").get_files().size()


func load_new_level():
	
	GameManager.switch_who_is_it()
	
	if !all_levels_seen:
		get_tree().call_deferred("change_scene_to_file", "res://project/scenes/levels/level" + str(curr_level + 1) + ".tscn")
		
		curr_level += 1
		
		if curr_level == num_levels:
			all_levels_seen = true
	else:
		var random_level = randi_range(1, num_levels)
		get_tree().call_deferred("change_scene_to_file", "res://project/scenes/levels/level" + str(random_level) + ".tscn")
