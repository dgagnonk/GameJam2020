extends Player


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	selected = false


func get_direction(_delta):
	yVelocity = -1 if is_on_wall() and Input.is_action_just_pressed("jump" + action_suffix) and selected else min(1,yVelocity+(_delta*2))
	
	return Vector2(
		yVelocity,
		Input.get_action_strength("move_left" + action_suffix) -Input.get_action_strength("move_right" + action_suffix) if selected else 0
	)

func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.y = speed.y * direction.y
	if direction.x != 0.0:
		velocity.x = speed.x * direction.x
	if is_jump_interrupted:
		velocity.x = 0.0
	return velocity
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
