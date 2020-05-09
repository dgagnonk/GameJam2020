extends RigidBody2D


export(Vector2) var gravity_vector


# Called when the node enters the scene tree for the first time.
func _ready():
	$GravityController.set_gravity_direction(gravity_vector)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


