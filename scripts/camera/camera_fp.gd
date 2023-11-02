extends CharacterBody3D


#move variables
@export var move_speed: float = 10.0
@export var run_speed: float = 600.0

@export var look_speed: float = 0.1

#jump variables
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent: float

var can_jump := true
var is_running := false


@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * 1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))* -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0


@onready var cam = $Camera3D
@onready var stats = $PlayerStats


func _physics_process(delta):
#	#handle running
	if Input.is_action_just_pressed("run_toggle"):
		is_running = true
	if Input.is_action_just_released("run_toggle"):
		is_running = false
	#get movement input
	var input_v = Input.get_vector("move_l", "move_r", "move_f", "move_b")
	#convert to move vector
	var move_v
	if input_v.length() >= 0.1:
		move_v = Vector3(input_v.x, 0, input_v.y).normalized() * get_move_speed() * delta
	else:
		move_v = Vector3.ZERO
	move_v = move_v.rotated(Vector3.UP, rotation.y)
	#smoothen movement
	velocity.x = lerp(velocity.x, move_v.x, 0.2)
	velocity.z = lerp(velocity.z, move_v.z, 0.2)
	
	#handle gravity
	velocity.y -= get_gravity() * delta
	if is_on_floor():
		#if on floor reset gravity and jump
		velocity.y = -get_gravity() * delta
		can_jump = true
	#handle jump
	if Input.is_action_just_pressed("jump") and can_jump:
		can_jump = false
		velocity.y = jump_velocity
	#apply movement
	move_and_slide()


func _input(event):
	#get mouse motion
	if event is InputEventMouseMotion:
		var input_v = event.relative
		#horizontal
		if abs(input_v.x) >= 0.1:
			var angle = deg_to_rad(-input_v.x * look_speed * 0.01)
			rotate(Vector3.UP, angle)
		#vertical
		if abs(input_v.y) >= 0.1:
			var angle = deg_to_rad(-input_v.y * look_speed * 0.005)
			cam.rotate_x(angle)
			cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -60.0, 60.0)



func get_gravity():
	if velocity.y > 0:
		return jump_gravity
	else:
		return fall_gravity


func get_move_speed() -> float:
	if is_running:
		print("Char is running. Speed:" + str(run_speed))
		stats.stamina -= stats.stamina_run_drain
		if stats.stamina <= 0:
			is_running = false
		return run_speed
	else:
		
		print("Char is walking. Speed:" + str(move_speed))
		return move_speed
