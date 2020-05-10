extends KinematicBody2D

onready var gate_closed = $Closed
onready var gate_open = $Open
onready var col_box = $CollisionShape2D

onready var is_closed = true

# item name required to interact with this object
# interaction code for the gate is in InteractableArea.gd
export(String) var requires_item = "red_key"

# if set to false, "locks" the interactable - it won't be usable
export(bool) var is_interactable = true

# event name that gets sent to EventBus
export(String) var interact_action = "toggle_gate_open"

func _ready():
	EventBus.connect("toggle_gate_open", self, "on_gate_toggle")
	EventBus.connect("force_gate_open", self, "on_force_gate_open")
	EventBus.connect("force_gate_close", self, "on_force_gate_close")

func closeGate():
	is_closed = true
	gate_closed.show()
	gate_open.hide()
	set_collision_mask_bit(0, true)
	
func openGate():
	is_closed = false
	gate_closed.hide()
	gate_open.show()
	set_collision_mask_bit(0, false)	

func toggleGateOpen():
	if is_closed:
		openGate()
	else:
		closeGate()

	is_closed = !is_closed

func on_force_gate_close(gate_name):
	closeGate()
	
func on_force_gate_open(gate_name):
	openGate()
	
func on_gate_toggle(gate_name):
	if gate_name == name:
		toggleGateOpen()
	



