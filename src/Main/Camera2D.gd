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
	anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	current = true
	activePlayer = get_tree().get_nodes_in_group("players")[0]
	inactivePlayer = get_tree().get_nodes_in_group("players")[1]
	startPos = activePlayer.position
	endPos = activePlayer.position
	endTime = movementTime


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	globalClock += _delta
	var targetPos = activePlayer.position
	var cameraCenter = get_parent().position
	var delta = (targetPos - cameraCenter)
	var direction = delta.normalized()
	var deltaLength = delta.length()
	var proposedMovement = direction * movementSpeed
	var proportion = (cameraCenter - inactivePlayer.position).length() / (activePlayer.position - inactivePlayer.position).length()

	if(constantSpeed):
		if(deltaLength < proposedMovement.length()):
			get_parent().position = activePlayer.position
			rotation = activePlayer.rotation
		else:
			get_parent().position += direction * movementSpeed
			rotation = lerp_angle(inactivePlayer.rotation, activePlayer.rotation, proportion)
	else:
		var iterator = clamp((globalClock - startTime) / movementTime,0,1)
		get_parent().position = lerp(startPos, endPos, iterator)
		rotation = lerp_angle(inactivePlayer.rotation, activePlayer.rotation, iterator)
		#get_parent().position = endPos
		#print(iterator)
	
	
func _input(event):
	if event.is_action_released("switch_character"):
		startPos = get_parent().position
		endPos = inactivePlayer.position
		var temp = activePlayer
		activePlayer = inactivePlayer
		inactivePlayer = temp
		#var endpos = activePlayer.position
		startTime = globalClock
		endTime = startTime + movementTime
