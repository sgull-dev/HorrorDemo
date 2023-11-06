extends Control


func _ready():
	visible = false


func quit_game():
	get_tree().quit()


func _on_button_button_down():
	quit_game()
