extends Node3D

var can_interact := false

var hud


func _ready():
	hud = GameData.get_current_stage().get_node("HUD/LockViewer")


func _input(event):
	if can_interact and !hud.menu_open:
		if event.is_action_pressed("interact"):
			look_at_lock()


func look_at_lock():
	#open lock HUD
	hud.open_menu()


func _on_interact_area_body_entered(body):
	if "is_player" in body:
		can_interact = true


func _on_interact_area_body_exited(body):
	if "is_player" in body:
		can_interact = false
