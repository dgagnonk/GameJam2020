extends RigidBody2D

export(Vector2) var gravity_vector = Vector2(1,0) setget set_gravity_vector

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_gravity_vector(value):
	$Gravity.set("gravity_vec", value)
