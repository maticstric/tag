extends Node

var current_it
var curr_level = 0
var all_levels_seen = false

@onready var num_levels = DirAccess.open("res://project/scenes/levels/").get_files().size()

func switch_who_is_it():
	if current_it == 1:
		current_it = 2
	else:
		current_it = 1
	
	
func start_game():
	current_it = randi_range(1, 2)
	load_new_level()
	
	
func next_level():
	switch_who_is_it()
	load_new_level()
	
	
func load_new_level():
	curr_level += 1
	
	if !all_levels_seen:
		get_tree().call_deferred("change_scene_to_file", "res://project/scenes/levels/level" + str(curr_level) + ".tscn")
		
		if curr_level == num_levels:
			all_levels_seen = true
			
	else:
		var random_level = randi_range(1, num_levels)
		curr_level = random_level
		
		get_tree().call_deferred("change_scene_to_file", "res://project/scenes/levels/level" + str(random_level) + ".tscn")
