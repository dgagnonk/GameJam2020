extends RigidBody2D


export(Vector2) var gravity_vector


# Called when the node enters the scene tree for the first time.
func _ready():
	rotate(PI)
	$GravityController.set_gravity_direction(-gravity_vector)
	
func orient_to_gravity(angle):
	set_mode(RigidBody2D.MODE_KINEMATIC)
	rotate(-angle)
	set_mode(RigidBody2D.MODE_CHARACTER)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


