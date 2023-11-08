extends Node3D

@export var volume_level := -15

var current_track := 0 		#index value for track( 0 nothing, 1 walk, 2 run


var toning_1 := false
var toning_2 := false

var interrupt_1 := false
var interrupt_2 := false

@onready var player = $".."
@onready var walk = $WalkSFX
@onready var run = $RunSFX


func _process(delta):
	print(current_track)
	#match state and player movement state to blend track volumes
	if current_track == 0:
		if player.move_v.length() <= 0.1:
			current_track = 0
			return
		elif !player.is_running:
			current_track = 1
			walk.volume_db = volume_level
			walk.play()
			if toning_1:
				interrupt_1 = true
			#tone_up_track(1)
		elif player.is_running:
			current_track = 2
			run.volume_db = volume_level
			run.play()
			if toning_2:
				interrupt_2 = true
			#tone_up_track(2)
	
	if current_track == 1:
		if player.move_v.length() <= 0.1:
			current_track = 0
			#tone_down_track(1)
			tone_down_track(1)
		elif !player.is_running:
			current_track = 1
			return
		elif player.is_running:
			current_track = 2
			run.play()
			run.volume_db = volume_level
#			tone_down_track(1)
#			tone_up_track(2)
			walk.stop()
			if toning_2:
				interrupt_2 = true
	
	if current_track == 2:
		if player.move_v.length() <= 0.1:
			current_track = 0
			tone_down_track(2)
		elif !player.is_running:
			current_track = 1
			walk.play()
			walk.volume_db = volume_level
			#tone_up_track(1)
			tone_down_track(2)
			if toning_1:
				interrupt_1 = true
		elif player.is_running:
			current_track = 2
			return


func tone_down_track(track):
	var amount = 40.0
	while amount >= 0:
		match track:
			1:
				if interrupt_1:
					interrupt_1 = false
					return
				walk.volume_db -= 4
			2:
				if interrupt_2:
					interrupt_2 = false
					return
				run.volume_db -= 4
		amount -= 4
		await get_tree().process_frame
	match track:
		1:
			walk.stop()
		2:
			run.stop()
	
