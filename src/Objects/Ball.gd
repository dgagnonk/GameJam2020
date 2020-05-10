extends RigidBody2D


export(Vector2) var gravity_vector


# Called when the node enters the scene tree for the first time.
func _ready():
	$GravityController.set_gravity_direction(gravity_vector)
	connect("body_entered",self,"on_body_entered")



