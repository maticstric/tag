extends CharacterBody2D

const MOVE_SPEED = 800
const DUCK_MOVE_SPEED = 150
const DUCK_FRICTION = 0.03
const JUMP_HEIGHT = 300
const JUMP_TIME_TO_PEAK = 0.35
const JUMP_TIME_TO_DESCENT = 0.3
const JUMP_END_EARLY_GRAVITY_MODIFIER = 2

@onready var jump_velocity = -(2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK
@onready var jump_gravity = -(-2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK ** 2
@onready var fall_gravity = -(-2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_DESCENT ** 2


func _physics_process(delta):
	
	
	print("jumpvel: " + str(jump_velocity))
	print(jump_gravity)
	print(fall_gravity)
	
	# If you're pressing duck or can't stand up, duck. Otherwise, walk
	# TODO: Probably add idle?
	if Input.is_action_pressed("duck") or !can_stand():
		$AnimationPlayer.play("duck")
		
		# If you're slower than DMS, go directly to it. If you're faster, go to it slowly
		if abs(velocity.x) <= DUCK_MOVE_SPEED:
			velocity.x = get_input_velocity() * float(DUCK_MOVE_SPEED)
		else:
			velocity.x = lerp(velocity.x, get_input_velocity() * float(DUCK_MOVE_SPEED), DUCK_FRICTION)
	else:
		$AnimationPlayer.play("walk")
		velocity.x = get_input_velocity() * MOVE_SPEED	
	
	process_jump()
	
	velocity.y += get_gravity() * delta
	
	move_and_slide()
	
	
func duck():
	velocity.x = lerp(velocity.x, 0.0, 0.03)
	
	
func process_jump():
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump()
	
	
func jump():
	velocity.y = jump_velocity
	
	
func ended_jump_early():
	return (!is_on_floor() and !Input.is_action_pressed("jump") and velocity.y < 0)
	
	
func can_stand():
	return !$HeadCheckArea2D.has_overlapping_bodies()
	
	
func get_input_velocity():
	var horizontal = 0.0
	
	if Input.is_action_pressed("left"):
		horizontal = -1.0
	
	if Input.is_action_pressed("right"):
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
