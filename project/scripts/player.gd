extends CharacterBody2D

const MOVE_SPEED = 500
const JUMP_HEIGHT = 250
const JUMP_TIME_TO_PEAK = 0.35
const JUMP_TIME_TO_DESCENT = 0.3

@onready var jump_velocity = -(2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK
@onready var jump_gravity = -(-2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK ** 2
@onready var fall_gravity = -(-2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_DESCENT ** 2


func _physics_process(delta):
	velocity.x = get_input_velocity() * MOVE_SPEED
	velocity.y += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump()
	
	move_and_slide()
	
	
func jump():
	velocity.y = jump_velocity
	
	
func get_input_velocity():
	var horizontal = 0.0
	
	if Input.is_action_pressed("left"):
		horizontal = -1.0
	
	if Input.is_action_pressed("right"):
		horizontal = 1.0
		
	return horizontal
	
	
func get_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity
