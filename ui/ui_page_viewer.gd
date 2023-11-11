extends Control

var menu_open := false
var data

@onready var paper_img = $PaperImg
@onready var side_bar = $PaperViewButtons
@onready var buttons = [
	$PaperViewButtons/VBoxContainer/Button1,
	$PaperViewButtons/VBoxContainer/Button2,
	$PaperViewButtons/VBoxContainer/Button3,
	$PaperViewButtons/VBoxContainer/Button4,
	$PaperViewButtons/VBoxContainer/Button5
	]

func _ready():
	visible = false
	data = GameData.get_current_stage().get_node("Systems/PaperData")


func _input(event):
	if menu_open:
		if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_end"):
			close_menu()
	if event.is_action_pressed("menu_paper"):
		if menu_open:
			close_menu()
		elif !menu_open:
			open_menu()


func open_menu():
	GameData.change_game_state(GameData.GAME_STATE.MENU)
	menu_open = true
	visible = true
	side_bar.visible = true
	
	var i = 0
	while i < buttons.size():
		if data.papers[i] == false:
			buttons[i].disabled = true
		else:
			buttons[i].disabled = false
		i += 1


func close_menu():
	GameData.change_game_state(GameData.GAME_STATE.PLAY)
	menu_open = false
	visible = false


func flash_paper(paper_index):
	open_menu()
	side_bar.visible = false
	set_paper_texture(paper_index)
	$AudioStreamPlayer.play()


func set_paper_texture(paper_index):
	var texture
	match paper_index:
		0:
			texture = load("res://assets/ui/pages/page_1.png")
		1:
			texture = load("res://assets/ui/pages/page_2.png")
		2:
			texture = load("res://assets/ui/pages/page_3.png")
		3:
			texture = load("res://assets/ui/pages/page_4.png")
		4:
			texture = load("res://assets/ui/pages/page_5.png")
	paper_img.texture = texture


func _on_return_button_button_down():
	close_menu()


func _on_button_1_button_down():
	set_paper_texture(0)


func _on_button_2_button_down():
	set_paper_texture(1)


func _on_button_3_button_down():
	set_paper_texture(2)


func _on_button_4_button_down():
	set_paper_texture(3)


func _on_button_5_button_down():
	set_paper_texture(4)
