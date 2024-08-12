extends CharacterBody2D

const MOVE_SPEED = 700
const DUCK_MIN_MOVE_SPEED = 150
const DUCK_SPEED_BOOST = 400
const DUCK_FRICTION = 0.05
const JUMP_HEIGHT = 300
const JUMP_TIME_TO_PEAK = 0.35 # in seconds
const JUMP_TIME_TO_DESCENT = 0.3 # in seconds
const JUMP_END_EARLY_GRAVITY_MODIFIER = 2
const JUMP_BUFFER = 100 # in milliseconds

@export_group("Action Names")
@export var left_action: String
@export var right_action: String
@export var jump_action: String
@export var duck_action: String

@export_group("Animation Names")
@export var walk_animation: String
@export var duck_animation: String

@onready var jump_velocity = -(2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK
@onready var jump_gravity = -(-2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK ** 2
@onready var fall_gravity = -(-2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_DESCENT ** 2

var has_buffered_jump = false
var time_jump_was_pressed = -1

func _physics_process(delta):
	
	if Input.is_action_just_pressed(duck_action):
		velocity.x += get_input_velocity() * DUCK_SPEED_BOOST
	
	# If you're pressing duck or can't stand up, duck. Otherwise, walk
	# TODO: Probably add idle?
	if Input.is_action_pressed(duck_action) or !can_stand():
		$AnimationPlayer.play(duck_animation)
		
		# If you're slower than DMMS, go directly to it. If you're faster, go to it slowly
		if abs(velocity.x) <= DUCK_MIN_MOVE_SPEED:
			velocity.x = get_input_velocity() * float(DUCK_MIN_MOVE_SPEED)
		else:
			velocity.x = lerp(velocity.x, get_input_velocity() * float(DUCK_MIN_MOVE_SPEED), DUCK_FRICTION)
	else:
		$AnimationPlayer.play(walk_animation)
		velocity.x = get_input_velocity() * MOVE_SPEED	
	
	process_jump()
	
	velocity.y += get_gravity() * delta
	
	move_and_slide()
	
	
func process_jump():
	# Process buffered jumps
	if is_on_floor() and time_jump_was_pressed > Time.get_ticks_msec() - JUMP_BUFFER:
		jump()
	
	if Input.is_action_just_pressed(jump_action):
		if is_on_floor():
			jump()
		else:
			time_jump_was_pressed = Time.get_ticks_msec()
	
	
func jump():
	velocity.y = jump_velocity
	
	
func ended_jump_early():
	return (!is_on_floor() and !Input.is_action_pressed(jump_action) and velocity.y < 0)
	
	
func can_stand():
	return !$HeadCheckArea2D.has_overlapping_bodies()
	
	
func get_input_velocity():
	var horizontal = 0.0
	
	if Input.is_action_pressed(left_action):
		horizontal = -1.0
	
	if Input.is_action_pressed(right_action):
		horizontal = 1.0
		
	return horizontal
	
	
func get_gravity():
	#return jump_gravity if velocity.y < 0.0 else fall_gravity
	if velocity.y < 0.0:
		if ended_jump_early():
			return fall_gravity * JUMP_END_EARLY_GRAVITY_MODIFIER
		else:
			return jump_gravity
	else:
		return fall_gravity
