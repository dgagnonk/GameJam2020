extends Area2D

export(String) var trigger_event
export(String) var trigger_event_data

onready var off_sprite = $off
onready var on_sprite = $on

var current_collisions = []

func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	off_sprite.visible = true
	on_sprite.visible = false
	
func on_body_entered(body):
	if body.can_use_buttons:
		on_sprite.visible = true
		off_sprite.visible = false
		current_collisions.append(body.name)
		EventBus.emit_signal(trigger_event, trigger_event_data)
		
func on_body_exited(body):
	if body.can_use_buttons:
		current_collisions.remove(body.name)
		if len(current_collisions) == 0:
			on_sprite.visible = false
			off_sprite.visible = true			
			EventBus.emit_signal(trigger_event, trigger_event_data)
