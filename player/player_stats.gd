extends Node

@export var max_health = 10.0
@export var max_stamina = 100.0
@export var stamina_gain = 50.0
@export var stamina_run_drain = 1.0

var health : float = 10.0
var stamina : float = 100.0


func _process(delta):
	stamina += stamina_gain * delta
	if stamina > max_stamina:
		stamina = max_stamina


func take_damage(amount):
	health -= amount
	if health <= 0:
		die()


func heal(amount):
	health += amount
	if health >= max_health:
		health = max_health


func die():
	get_tree().quit()


