extends CharacterBody2D

var MOVE_SPEED = 700 # var so I can change it in play_again_screen
const WALL_JUMP_SPEED = 1000
const MOVE_ACCELERATION = 170
const IN_AIR_MOVE_ACCELERATION = 100
const DUCK_MIN_MOVE_SPEED = 150
const DUCK_SPEED_BOOST = 500
const DUCK_FRICTION = 0.05
const JUMP_HEIGHT = 300
const JUMP_TIME_TO_PEAK = 0.35 # in seconds
const JUMP_TIME_TO_DESCENT = 0.3 # in seconds
const JUMP_END_EARLY_GRAVITY_MODIFIER = 2
const JUMP_BUFFER = 100 # in milliseconds
const COYOTE_TIME_THRESHOLD = 60 # in milliseconds

@onready var left_action = "left" + str(player_num)
@onready var right_action = "right" + str(player_num)
@onready var jump_action = "jump" + str(player_num)
@onready var duck_action = "duck" + str(player_num)

@onready var walk_animation = "walk" + str(player_num)
@onready var duck_animation = "duck" + str(player_num)

@onready var jump_velocity = -(2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK
@onready var jump_gravity = -(-2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK ** 2
@onready var fall_gravity = -(-2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_DESCENT ** 2

@export var player_num = 1
var is_it = false
var has_buffered_jump = false
var time_jump_was_pressed = -1
var time_player_was_last_on_floor = -1
@export var movement_enabled = false

func _ready():
	if is_it:
		$Sprite2D.material = ShaderMaterial.new()
		$Sprite2D.material.set_shader_parameter("pattern", 1)
		$Sprite2D.material.shader = load("res://project/shaders/outline.gdshader")
		
		$ITLabel.visible = true
	
	
func _physics_process(delta):
	var input_velocity = get_input_velocity()
	
	if is_on_floor():
		time_player_was_last_on_floor = Time.get_ticks_msec()
	
	if Input.is_action_just_pressed(duck_action) and can_stand():
		velocity.x += input_velocity * DUCK_SPEED_BOOST
	
	# If you're pressing duck or can't stand up, duck. Otherwise, walk
	# TODO: Probably add idle?
	if Input.is_action_pressed(duck_action) or !can_stand():
		$AnimationPlayer.play(duck_animation)
		
		# If you're slower than DMMS, go directly to it. If you're faster, go to it slowly
		if abs(velocity.x) <= DUCK_MIN_MOVE_SPEED:
			velocity.x = input_velocity * float(DUCK_MIN_MOVE_SPEED)
		else:
			velocity.x = lerp(velocity.x, input_velocity * float(DUCK_MIN_MOVE_SPEED), DUCK_FRICTION)
	else:
		$AnimationPlayer.play(walk_animation)
		if is_on_floor():
			velocity.x = move_toward(velocity.x, input_velocity * MOVE_SPEED, MOVE_ACCELERATION)
		else:
			velocity.x = move_toward(velocity.x, input_velocity * MOVE_SPEED, IN_AIR_MOVE_ACCELERATION)
	
	process_wall_jump()
	process_jump()
	
	velocity.y += _get_gravity() * delta
	
	if movement_enabled:
		move_and_slide()
	
	
func is_near_wall():
	return $RightWallCheckRayCast2D.is_colliding() or $LeftWallCheckRayCast2D.is_colliding()
	
	
func get_wall_direction():	
	if $RightWallCheckRayCast2D.is_colliding():
		return $RightWallCheckRayCast2D.target_position.normalized()
	elif $LeftWallCheckRayCast2D.is_colliding():
		return $LeftWallCheckRayCast2D.target_position.normalized()
	
	
func process_wall_jump():
	if Input.is_action_just_pressed(jump_action) and !is_on_floor() and is_near_wall():
		var wall_normal = get_wall_direction() * -1
		wall_jump(wall_normal)
	
	
func process_jump():
	# Process buffered jumps
	if is_on_floor() and time_jump_was_pressed > Time.get_ticks_msec() - JUMP_BUFFER:
		jump()
	
	if Input.is_action_just_pressed(jump_action):
		if is_on_floor() or time_player_was_last_on_floor + COYOTE_TIME_THRESHOLD > Time.get_ticks_msec():
			jump()
		else:
			time_jump_was_pressed = Time.get_ticks_msec()
	
	
func jump():
	velocity.y = jump_velocity
	
	
func wall_jump(wall_normal):
	velocity.y = jump_velocity
	velocity.x = wall_normal.x * WALL_JUMP_SPEED
	
	
func ended_jump_early():
	return (!is_on_floor() and !Input.is_action_pressed(jump_action) and velocity.y < 0)
	
	
func can_stand():
	return !$HeadCheckArea2D.has_overlapping_bodies()
	
	
func get_input_velocity():
	var horizontal = 0.0
	
	if Input.is_action_pressed(left_action):
		horizontal = -1
	if Input.is_action_pressed(right_action):
		horizontal = 1
	
	return horizontal
	
	
func _get_gravity():
	#return jump_gravity if velocity.y < 0.0 else fall_gravity
	if velocity.y < 0.0:
		if ended_jump_early():
			return fall_gravity * JUMP_END_EARLY_GRAVITY_MODIFIER
		else:
			return jump_gravity
	else:
		return fall_gravity
	
	
func _on_tag_check_area_2d_area_entered(area):
	if area.is_in_group("player") and is_it:
		GameManager.next_level(GameManager.TAGGED)
