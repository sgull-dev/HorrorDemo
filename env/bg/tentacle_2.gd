extends Node3D

var popping_up := false
var pop_up_amount : float
var popped := false

@onready var anim = $AnimationPlayer
@onready var area = $PlayerSeeArea


func _ready():
	global_position.y -= 4.0
	pop_up_amount = -4.0
	#anim.play("Wiggle")


func _process(delta):
	if popping_up:
		global_position.y += 9.0 * delta
		pop_up_amount += 9.0 * delta
		if pop_up_amount >= -0.2:
			popping_up = false
			popped = true
	if popped:
		if !anim.is_playing():
			anim.play("Wiggle3")
			anim.speed_scale = 1.0
	


func pop_up():
	popping_up = true
	anim.play("Wiggle2")
	anim.queue("Wiggle3")

func _on_player_see_area_body_entered(body):
	if "is_player" in body:
		pop_up()
