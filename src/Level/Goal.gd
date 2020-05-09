extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

	
func on_body_entered(body):
	if body is Player:
		EventBus.emit_signal("goal", true, body)

func on_body_exited(body):
	if body is Player:
		EventBus.emit_signal("goal", false, body)

