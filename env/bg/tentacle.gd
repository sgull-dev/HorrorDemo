extends CSGCylinder3D

@onready var anim = $AnimationPlayer


func _ready():
	#randomize anim speed
	anim.speed_scale = randf_range(0.6, 1.2)
	#start anim
	anim.play("Tent")
