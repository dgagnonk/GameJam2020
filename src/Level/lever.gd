extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(bool) var is_interactable = true
export(String) var interact_action = "reverse_gravity"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	
func on_body_entered(body):
	if body is Player:
		body.nearest_interactable = self
		
func on_body_exited(body):
	if body is Player:
		body.nearest_interactable = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
