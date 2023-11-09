extends Control

@export var load_time := 3.0

var next_scene = preload("res://stages/stage_1.tscn")


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameData.change_game_state(GameData.GAME_STATE.PLAY)
	
	$Timer.start(load_time)
	await $Timer.timeout
	restart_game()


func restart_game():
	#load stage again
	get_tree().change_scene_to_packed(next_scene)

