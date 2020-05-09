extends KinematicBody2D

onready var gate_closed = $Closed
onready var gate_open = $Open
onready var col_box = $CollisionShape2D

onready var is_closed = true

export(String) var requires_item = ""
export(bool) var is_interactable = true

func _ready():
	col_box.disabled = false

func _input(event):
	if event.is_action_released("test_key"):
		if is_closed:
			gate_closed.hide()
			gate_open.show()
		else:
			gate_closed.show()
			gate_open.hide()
	
		is_closed = !is_closed
		col_box.disabled = !is_closed
	
