extends Camera2D
var activePlayer: Player
var inactivePlayer: Player
export var movementSpeed = 1
export var movementTime = 2
var startPos
var endPos
var globalClock = 0
var startTime = 0
var endTime = 0
export var constantSpeed = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("toggle_birds_eye",self,"on_toggle_birds_eye")
	anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	current = true
	var players = get_tree().get_nodes_in_group("players")
	activePlayer = players[0]
	inactivePlayer = players[1]
	startPos = activePlayer.global_position
	endPos = activePlayer.global_position
	endTime = movementTime


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	globalClock += _delta
	var targetPos = activePlayer.global_position
	var cameraCenter = get_parent().global_position
	var delta = (targetPos - cameraCenter)
	var direction = delta.normalized()
	var deltaLength = delta.length()
	var proposedMovement = direction * movementSpeed
	var proportion = (cameraCenter - inactivePlayer.position).length() / (activePlayer.position - inactivePlayer.position).length()
	endPos = targetPos

	if(constantSpeed):
		if(deltaLength < proposedMovement.length()):
			get_parent().global_position = activePlayer.position
			rotation = activePlayer.rotation
		else:
			get_parent().global_position += direction * movementSpeed
			rotation = lerp_angle(inactivePlayer.rotation, activePlayer.rotation, proportion)
	else:
		var iterator = clamp((globalClock - startTime) / movementTime,0,1)
		get_parent().global_position = lerp(startPos, endPos, iterator)
		rotation = lerp_angle(inactivePlayer.rotation, activePlayer.rotation, iterator)
		#get_parent().position = endPos
		#print(iterator)
	
	
func on_toggle_birds_eye(birds_eye_on):
		if !birds_eye_on:
			current = true	
	
	
func _input(event):
	if event.is_action_released("switch_character"):
		#startPos = get_parent().global_position
		#endPos = inactivePlayer.global_position
		var temp = activePlayer
		activePlayer = inactivePlayer
		inactivePlayer = temp
		#var endpos = activePlayer.position
		startTime = globalClock
		endTime = startTime + movementTime
