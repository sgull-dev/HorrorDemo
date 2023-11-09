extends Node3D

var is_stage = true


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameData.change_game_state(GameData.GAME_STATE.PLAY)
