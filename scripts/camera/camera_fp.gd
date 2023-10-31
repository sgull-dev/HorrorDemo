extends CharacterBody3D


#move variables
@export var move_speed: float = 10.0
@export var look_speed: float = 0.1

#jump variables
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent: float

var can_jump := true

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * 1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))* -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0


@onready var cam = $Camera3D


func _process(delta):
	var input_v = Input.get_vector("move_l", "move_r", "move_f", "move_b")
	
	var move_v = Vector3(input_v.x, 0, input_v.y).normalized() * move_speed * delta
	move_v = move_v.rotated(Vector3.UP, rotation.y)
	
	velocity.x = lerp(velocity.x, move_v.x, 0.2)
	velocity.z = lerp(velocity.z, move_v.z, 0.2)
	
	velocity.y -= get_gravity() * delta
	if is_on_floor():
		velocity.y = -get_gravity() * delta
		can_jump = true
	if Input.is_action_just_pressed("jump") and can_jump:
		can_jump = false
		velocity.y = jump_velocity
	
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
