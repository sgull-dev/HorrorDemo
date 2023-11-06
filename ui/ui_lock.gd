extends Control

var menu_open := false


func _ready():
	visible = false


func _input(event):
	if menu_open:
		if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_end"):
			close_menu()


func open_menu():
	GameData.change_game_state(GameData.GAME_STATE.MENU)
	menu_open = true
	visible = true


func close_menu():
	GameData.change_game_state(GameData.GAME_STATE.PLAY)
	menu_open = false
	visible = false
