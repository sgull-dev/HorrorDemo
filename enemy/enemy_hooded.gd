extends CharacterBody3D

enum MOVE_MODE { WANDER, CHASE }
var move_mode = MOVE_MODE.WANDER

#radius inside of which the enemy will wander around (around the init_pos)
@export var wander_radius : float = 34.0
@export var wander_speed : float = 150.0
@export var chase_speed : float = 350.0
@export var wander_delay_time : float = 1.0
@export var chase_no_lose_time : float = 1.0

#initial position of the enemy
var init_position : Vector3
#target position for the nav agent
var target_position : Vector3

var time_from_path_finish : float
var time_from_chase_start : float
var nav_delay_frames = 2
#link to HUD for displaying jumpscare/lose screen
var lose_hud
var player
@onready var agent = $NavigationAgent3D


func _ready():
	lose_hud = GameData.get_current_stage().get_node("HUD/LoseScreen")
	player = GameData.get_current_stage().get_node("Player")
	#set init position
	init_position = global_position
	set_random_wander_pos()


func _physics_process(delta):
	if nav_delay_frames > 0:
		nav_delay_frames -= 1
		return
	
	var move_v
	#handle movement code
	#if agent has reached end of path, stop movement for a while, then get new target pos
	if agent.is_navigation_finished():
		#set movement to halt
		move_v = Vector3.ZERO
		time_from_path_finish += delta
		if time_from_path_finish >= wander_delay_time:
			set_random_wander_pos()
			time_from_path_finish = 0.0
	elif move_mode == MOVE_MODE.WANDER:
		var next_path_pos = agent.get_next_path_position()
		var dir_v = (next_path_pos - global_position).normalized()
		move_v = get_speed() * dir_v * delta
	elif move_mode == MOVE_MODE.CHASE:
		#set target to player
		agent.target_position = player.global_position
		#set movement
		var next_path_pos = agent.get_next_path_position()
		var dir_v = (next_path_pos - global_position).normalized()
		move_v = get_speed() * dir_v * delta
		#add time to chase start
		time_from_chase_start += delta
		if time_from_chase_start >= chase_no_lose_time:
			#if larger than chase no lose time, start checking if player has gotten outside see radius
			if (global_position - player.global_position).length() > $PlayerSeeArea/CollisionShape3D.shape.radius:
				move_mode = MOVE_MODE.WANDER
				set_random_wander_pos()
	
	#apply smoothing to movement
	velocity.x = lerp(velocity.x, move_v.x, 0.2)
	velocity.z = lerp(velocity.z, move_v.z, 0.2)
	#apply movement
	move_and_slide()


func _on_jump_scare_area_body_entered(body):
	#if player entered jumpscare area
	if "is_player" in body:
		#trigger jump scare
		lose_hud.trigger_lose_game()


func set_random_wander_pos():
	var pos = init_position
	#vary the pos by radius
	pos.x += randf_range(-wander_radius, wander_radius)
	pos.z += randf_range(-wander_radius, wander_radius)
	#clamp the position inside a wander_radius around the init_position 
	var dist_v = pos - init_position
	var dist = dist_v.length()
	#if distance is too far
	if dist > wander_radius:
		#set pos to be on the dist_v a wander_radius away from init_pos
		var dir_v = dist_v.normalized()
		pos = init_position
		pos += dir_v * wander_radius
	#set target position
	target_position = pos
	agent.target_position = target_position


func get_speed() -> float:
	if move_mode == MOVE_MODE.WANDER:
		return wander_speed
	else:
		return chase_speed


func spot_player():
	move_mode = MOVE_MODE.CHASE
	time_from_chase_start = 0.0


func _on_player_see_area_body_entered(body):
	if "is_player" in body:
		spot_player()
