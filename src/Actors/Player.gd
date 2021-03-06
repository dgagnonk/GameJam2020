class_name Player
extends Actor


const FLOOR_DETECT_DISTANCE = 20.0

export(String) var action_suffix = ""


onready var platform_detector = $PlatformDetector
onready var interactable_detector = $InteractableDetector
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var shoot_timer = $ShootAnimation
onready var gun = $Sprite/Gun
onready var animations = $Animations

onready var yVelocity = 1
onready var xVelocity = 0
export(bool) var selected = true
export(Vector2) var gravity_vector = Vector2(0,1)

onready var nearest_interactable = null
export(Array) var inventory = []
onready var can_use_buttons = true

func _ready():

	#if selected:
		#get_node("Camera").current = true
	
	rotate(-gravity_vector.angle_to(Vector2(0,1)))
	
	EventBus.connect("reverse_gravity", self, "on_reverse_gravity")
	
	# Static types are necessary here to avoid warning
	#var camera: Camera2D = $Camera
	#if action_suffix == "_p1":
	#	camera.custom_viewport = $"../.."
	#elif action_suffix == "_p2":
	##	var viewport: Viewport = $"../../../../ViewportContainer2/Viewport"
	#	viewport.world_2d = ($"../.." as Viewport).world_2d
	#	camera.custom_viewport = viewport


func gravity_direction():
	if abs(gravity_vector.y) > 0:
		return gravity_vector.y
	else:
		return gravity_vector.x
		
func gravity_orientation():
	if abs(gravity_vector.y) > 0:
		return "vertical"
	else:
		return "horizontal"
		
func gravity_opposite_orientation():
	if abs(gravity_vector.y) > 0:
		return "horizontal"
	else:
		return "vertical"

# Physics process is a built-in loop in Godot.
# If you define _physics_process on a node, Godot will call it every frame.

# We use separate functions to calculate the direction and velocity to make this one easier to read.
# At a glance, you can see that the physics process loop:
# 1. Calculates the move direction.
# 2. Calculates the move velocity.
# 3. Moves the character.
# 4. Updates the sprite direction.
# 5. Shoots bullets.
# 6. Updates the animation.

# Splitting the physics process logic into functions not only makes it
# easier to read, it help to change or improve the code later on:
# - If you need to change a calculation, you can use Go To -> Function
#   (Ctrl Alt F) to quickly jump to the corresponding function.
# - If you split the character into a state machine or more advanced pattern,
#   you can easily move individual functions.
func _physics_process(_delta):
	var direction = get_direction(_delta)

	var is_jump_interrupted = Input.is_action_just_released("jump" + action_suffix) and _velocity.y < 0.0
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)

	var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE if direction.y == 0.0 else Vector2.ZERO
	var is_on_platform = platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)
	var push = 100
	# after calling move_and_slide()
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("balls"):
			collision.collider.apply_central_impulse(-collision.normal * push)

	# When the character’s direction changes, we want to to scale the Sprite accordingly to flip it
	var scaleX = get_sprite_scale(direction)
	if(scaleX != null):
		sprite.scale.x = scaleX

	var animation = get_new_animation()
	
	if gravity_orientation() == "vertical":
		if gravity_direction() > 0:
			animations.flip_h = direction.x < 0
		else:
			animations.flip_h = direction.x > 0
	else:
		if gravity_direction() > 0:
			animations.flip_h = direction.y > 0
		else:
			animations.flip_h = direction.y < 0
		
	animations.play(animation)

func get_sprite_scale(direction):
	if gravity_orientation() == "vertical":
		if direction.x != 0:
			return 1 if gravity_direction()*direction.x > 0 else -1
	else:
		if direction.y != 0:
			return 1 if gravity_direction()*direction.y < 0 else -1

func on_floor():
	if(gravity_orientation() == "vertical"):
		if(gravity_direction() == 1):
			return is_on_floor()
		else:
			return is_on_ceiling()
	else:
		return is_on_wall()

func on_reverse_gravity(orientation):
	if orientation == gravity_orientation():
		gravity_vector = -gravity_vector
		rotate(PI)

func get_direction(_delta):
	yVelocity = -1 if on_floor() and Input.is_action_just_pressed("jump" + action_suffix) and selected else min(1,yVelocity+(_delta*2))
	
	if on_floor():
		xVelocity = (Input.get_action_strength("move_right" + action_suffix) - Input.get_action_strength("move_left" + action_suffix)) if selected and on_floor() else 0
	else:
		xVelocity = xVelocity*(1-_delta)
	
	if gravity_orientation() == "vertical":
		return Vector2(
			gravity_direction()*xVelocity,
			gravity_direction()*yVelocity
		)
	else:
		return Vector2(
			gravity_direction()*yVelocity,
			-gravity_direction()*xVelocity
		)



func _input(event):
	if event.is_action_released("switch_character"):
		selected = !selected
		
		#if(selected):
		#	get_node("Camera").current = true

	if selected:
		if event.is_action_pressed("birds_eye"):
			EventBus.emit_signal("toggle_birds_eye", true)
		if event.is_action_released("birds_eye"):
			EventBus.emit_signal("toggle_birds_eye", false)
		if event.is_action_released("interact"):
			if (nearest_interactable
				and nearest_interactable.is_interactable):
					var interact_action_data
					
					if nearest_interactable.interact_action == "reverse_gravity":
						interact_action_data = gravity_opposite_orientation()
					else:
						interact_action_data = nearest_interactable.name
					EventBus.emit_signal(nearest_interactable.interact_action, interact_action_data)
				
# This function calculates a new velocity whenever you need it.
# It allows you to interrupt jumps.
func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	
	var velocity = linear_velocity
	
	if gravity_orientation() == "vertical":
		velocity.x = speed.x * direction.x
		if direction.y != 0.0:
			velocity.y = speed.y * direction.y
		if is_jump_interrupted:
			velocity.y = 0.0
	else:
		velocity.y = speed.x * direction.y
		if direction.x != 0.0:
			velocity.x = speed.y * direction.x
		if is_jump_interrupted:
			velocity.x = 0.0
	return velocity


func get_new_animation():
	var animation_new = ""
	if gravity_orientation() == "vertical":
		if on_floor():
			animation_new = "run" if abs(_velocity.x) > 0.1 else "idle"
		else:
			animation_new = "falling" if _velocity.y > 0 else "jumping"
	else:
		if on_floor():
			animation_new = "run" if abs(_velocity.y) > 0.1 else "idle"
		else:
			animation_new = "falling" if _velocity.x > 0 else "jumping"
	return animation_new
