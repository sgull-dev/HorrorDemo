extends Control

var menu_open := false

var data
var lock_combination = [1, 1, 1]
var correct_combination = [2, 7, 9]
var key_inserted := false

@onready var win = $"../WinScreen"


func _ready():
	visible = false
	data = GameData.get_current_stage().get_node("Systems/PaperData")


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


func turn_combination(index):
	#change combination value
	lock_combination[index] += 1
	if lock_combination[index] == 10:
		lock_combination[index] = 1
	#play sfx
	$Buttons/TurnSFX.play()
	#set text
	var str = "Number" + str(index + 1)
	get_node(str).text = str(lock_combination[index])


func insert_key():
	if data.papers[4] == true and !key_inserted:
		$KeyImg.visible = true
		$KeyImg/AudioStreamPlayer.play()
		key_inserted = true
	else:
		$Buttons/OpenButton/NoSFX.play()


func open_lock():
	if data.papers[4] == true:
		if lock_combination[0] == correct_combination[0]:
			if lock_combination[1] == correct_combination[1]:
				if lock_combination[2] == correct_combination[2]:
					#win game
					win.visible = true
					print_debug("Won game. Opening win screen.")
					#play sfx
					$Buttons/OpenButton/YesSFX.play()
				else:
					$Buttons/OpenButton/NoSFX.play()
			else:
				$Buttons/OpenButton/NoSFX.play()
		else:
			$Buttons/OpenButton/NoSFX.play()
	else:
		#play 'no' sfx
		$Buttons/OpenButton/NoSFX.play()


func _on_return_button_button_down():
	close_menu()


func _on_insert_key_button_button_down():
	insert_key()


func _on_open_button_button_down():
	open_lock()



func _on_num_1_button_button_down():
	turn_combination(0)


func _on_num_2_button_button_down():
	turn_combination(1)


func _on_num_3_button_button_down():
	turn_combination(2)
