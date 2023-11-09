extends AudioStreamPlayer3D

@export var time_range = [12.0, 30.0]

var time_delay := 5.0
var time_from_horn := 0.0


func _process(delta):
	time_from_horn += delta
	if time_from_horn >= time_delay:
		play_horn()
		time_from_horn = 0.0
		time_delay = randf_range(time_range[0], time_range[1])


func play_horn():
	play()
