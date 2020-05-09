extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func orient_parent(angle):
	var parent = get_parent()
	if parent.has_method("orient_to_gravity"):
		parent.orient_to_gravity(angle)


# Called when the node enters the scene tree for the first time.
func _ready():
	orient_parent(-gravity_vec.angle_to(Vector2(0,1)))
	EventBus.connect("reverse_gravity", self, "on_reverse_gravity")

func gravity_orientation():
	if(abs(gravity_vec.y) > 0):
		return "vertical"
	else:
		return "horizontal"

func set_gravity_direction(value):
	orient_parent(-gravity_vec.angle_to(value))
	gravity_vec = value
	
	get_parent().apply_impulse(Vector2(0,0),Vector2(0,0))

func on_reverse_gravity(orientation):
	if orientation == gravity_orientation():
		set_gravity_direction(-gravity_vec)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
