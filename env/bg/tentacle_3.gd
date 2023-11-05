extends Node3D

@export var pop_up_at_start := false

var popping_up := false
var pop_up_amount : float
var popped := false

@onready var anim = $tentacle_3/AnimationPlayer2
@onready var area = $PlayerSeeArea


func _ready():
	global_position.y -= 4.3
	pop_up_amount = -4.3
	#anim.play("Wiggle")
	if pop_up_at_start:
		pop_up()


func _process(delta):
	if popping_up:
		global_position.y += 9.0 * delta
		pop_up_amount += 9.0 * delta
		if pop_up_amount >= -0.2:
			popping_up = false
			popped = true
	if popped:
		if !anim.is_playing():
			anim.play("Wiggle_1")
			anim.speed_scale = randf_range(0.6, 1.1)


func pop_up():
	popping_up = true
	anim.play("Wiggle_1")
	anim.queue("Wiggle_1")


func _on_player_see_area_body_entered(body):
	if "is_player" in body:
		pop_up()


func _on_animation_player_2_animation_finished(_anim_name):
	anim.queue("Wiggle_1")
