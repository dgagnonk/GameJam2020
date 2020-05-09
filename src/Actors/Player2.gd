extends Player


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	selected = false


func on_floor():
	return is_on_wall()
	
func get_sprite_scale(direction):
	if direction.x != 0:
		return 1 if gravityDirection*direction.y < 0 else -1

func get_direction(_delta):
	yVelocity = -1 if on_floor() and Input.is_action_just_pressed("jump" + action_suffix) and selected else min(1,yVelocity+(_delta*2))
	
	return Vector2(
		gravityDirection * yVelocity,
		gravityDirection * (Input.get_action_strength("move_left" + action_suffix) -Input.get_action_strength("move_right" + action_suffix)) if selected else 0
	)

func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.y = speed.x * direction.y
	if direction.x != 0.0:
		velocity.x = speed.y * direction.x
	if is_jump_interrupted:
		velocity.x = 0.0
	return velocity
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_new_animation(is_shooting = false):
	var animation_new = ""
	if on_floor():
		animation_new = "run" if abs(_velocity.y) > 0.1 else "idle"
	else:
		animation_new = "falling" if _velocity.x > 0 else "jumping"
	if is_shooting:
		animation_new += "_weapon"
	return animation_new
