extends ProgressBar

var stats


func _ready():
	stats = GameData.get_current_stage().get_node("Player/PlayerStats")


func _process(delta):
	value = stats.stamina
