extends Node3D

@export var paper_index : int

var can_pickup := false

var data


func _ready():
	data = GameData.get_current_stage().get_node("Systems/PaperData")


func _input(event):
	if can_pickup:
		if event.is_action_pressed("interact"):
			pick_up()


func pick_up():
	print("Picked up paper with index: " + str(paper_index))
	#add paper to data with paper_index
	data.papers[paper_index] = true
	data.got_paper.emit(paper_index)
	queue_free()


func _on_area_3d_body_entered(body):
	if "is_player" in body:
		can_pickup = true


func _on_area_3d_body_exited(body):
	if "is_player" in body:
		can_pickup = false
