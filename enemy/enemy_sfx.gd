extends Node3D


@onready var sfx1 = $Breath1
@onready var sfx2 = $Breath2
@onready var sfx3 = $Claw

func _ready():
	breathe()
	claw()


func breathe():
	var rng = randi()%2
	match rng:
		0:
			sfx1.play()
		1:
			sfx2.play()
	
	var delay = randf_range(3.0, 12.0)
	$Timer.start(delay)
	await $Timer.timeout
	breathe()


func claw():
	sfx3.play()
	var delay = randf_range(4.0, 7.0)
	$Timer2.start(delay)
	await $Timer2.timeout
	claw()
