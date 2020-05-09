extends Area2D

var requires_item


func _ready():
	requires_item = get_parent().requires_item
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

func on_body_entered(body):
	if body is Player:
		if requires_item in body.inventory:
			print("Player has proper key")
		else:
			print("Does not have proper key")
		
func on_body_exited(body):
	print("Player left object region")
#	if body is Player:
#		body.switch_nearby = false
	
