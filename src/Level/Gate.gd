extends KinematicBody2D

onready var gate_closed = $Closed
onready var gate_open = $Open

onready var is_closed = true

func _input(event):
	if event.is_action_released("test_key"):
		if is_closed:
			gate_closed.hide()
			gate_open.show()
			is_closed = false
		else:
			gate_closed.show()
			gate_open.hide()
			is_closed = true
