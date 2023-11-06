extends Area3D

var activated := false

@onready var audio = $AudioStreamPlayer3D


func _on_body_entered(body):
	if "is_player" in body and !activated:
		audio.play()
		activated = true
