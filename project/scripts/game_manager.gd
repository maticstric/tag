extends Node

enum { TIME_RAN_OUT, TAGGED, PLAY_AGAIN }

const SCORE_IF_TAG = 1
const SCORE_IF_EVADE = 1

const MAX_SCORE = 10

var current_it
var curr_level = 0
var all_levels_seen = false

var muted = false

var p1_score = 0
var p2_score = 0

@onready var num_levels = DirAccess.open("res://project/scenes/levels/").get_files().size()

func switch_who_is_it():
	if current_it == 1:
		current_it = 2
	else:
		current_it = 1
	
	
func start_game():
	current_it = randi_range(1, 2)
	load_new_level()
	
	
func back_to_main_menu():
	p1_score = 0
	p2_score = 0
	curr_level = 0
	current_it = 0
	all_levels_seen = false
	
	get_tree().call_deferred("change_scene_to_file", "res://project/scenes/main_menu.tscn")
	
	
func play_again_screen():
	get_tree().call_deferred("change_scene_to_file", "res://project/scenes/play_again_screen.tscn")
	
func next_level(reason):
	if p1_score == MAX_SCORE or p2_score == MAX_SCORE:
		back_to_main_menu()
		return
		
	if reason == TAGGED:
		if current_it == 1:
			p1_score += SCORE_IF_TAG
		else:
			p2_score += SCORE_IF_TAG
		
		switch_who_is_it()
	else:
		if current_it == 1:
			p2_score += SCORE_IF_EVADE
		else:
			p1_score += SCORE_IF_EVADE
	
	if p1_score == MAX_SCORE or p2_score == MAX_SCORE:
		current_it = 1 if p1_score == MAX_SCORE else 2
		
		play_again_screen()
	else:
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
