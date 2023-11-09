extends Control

#var next_scene = preload("res://ui/load.tscn")

func _ready():
	visible = false


func trigger_lose_game():
	GameData.change_game_state(GameData.GAME_STATE.MENU)
	visible = true
	$VideoStreamPlayer.play()
	$JumpscareSFX.play()


func restart_game():
	#load stage again
	get_tree().change_scene_to_file("res://ui/load.tscn")
	#get_tree().reload_current_scene()

func _on_restart_button_button_down():
	restart_game()
