extends Area2D

var requires_item


func _ready():
	requires_item = get_parent().requires_item
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

func on_body_entered(body):
	print('trigger')
	if body is Player:
		if requires_item in body.inventory:
			body.nearest_interactable = get_parent()
		else:
			print("Player is in range of an interactable but has wrong item.")
			
func on_body_exited(body):
	if body is Player:
		body.nearest_interactable = null
	
