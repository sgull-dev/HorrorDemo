extends Node


@export var tracks := [AudioStream]
@export var levels :Array[float]

@onready var player = $AudioStreamPlayer


func _ready():
	play_ambiance()


func _process(delta):
	if !player.playing:
		play_ambiance()


func play_ambiance():
	print("AMB Player started playing.")
	#pick random ambiance track
	var rng = randi()%tracks.size()
	print("AMB chose track: " + str(rng))
	#set track
	player.stream = tracks[rng]
	#set volume
	player.volume_db = levels[rng]
	#TO-DO: Alter volume with audio settings from Settings AutoLoad
	player.volume_db -= 15
	#start the track playing
	player.play()
