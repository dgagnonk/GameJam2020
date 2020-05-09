extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("reverse_gravity", self, "on_reverse_gravity")

func gravity_orientation():
	if(abs(gravity_vec.y) > 0):
		return "vertical"
	else:
		return "horizontal"


func on_reverse_gravity(orientation):
	if orientation == gravity_orientation():
		gravity_vec = -gravity_vec
		get_parent().apply_impulse(Vector2(0,0),Vector2(0,0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
