extends Node

var current_it

func _ready():
	current_it = randi_range(1, 2)
	
	
func switch_who_is_it():
	if current_it == 1:
		current_it = 2
	else:
		current_it = 1
