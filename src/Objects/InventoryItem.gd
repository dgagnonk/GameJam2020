extends Area2D

export(bool) var vertical_bounce = true
var t = 0
var upper_pos #upper limit of the "bounce" effect
var lower_pos #lower limit of the "bounce" effect
var going_to_pos #current position the item is bouncing to

func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	if vertical_bounce:
		upper_pos = self.position + Vector2(0, 3)
	else:
		upper_pos = self.position + Vector2(3, 0)
		
	lower_pos = self.position
	
func _physics_process(delta):
	if self.position == upper_pos:
		going_to_pos = lower_pos
		t = 0
	elif self.position == lower_pos:
		going_to_pos = upper_pos
		t = 0
		
	t += delta
	self.position = self.position.linear_interpolate(going_to_pos, t)
	
func on_body_entered(body):
	if body is Player:
		body.inventory.append(self.name)
		self.queue_free() # delete object after being acquired
		
func on_body_exited(body):
	if body is Player:
		body.nearest_interactable = null
