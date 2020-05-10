extends RigidBody2D
class_name Ball

export(Vector2) var gravity_vector

export(bool) var can_use_buttons

# Called when the node enters the scene tree for the first time.
func _ready():
	$GravityController.set_gravity_direction(gravity_vector)
	connect("body_entered",self,"on_body_entered")

#func on_body_entered(body):
	#if body is TriggerButton:
		#body.apply_impulse(-body.applied_force)


