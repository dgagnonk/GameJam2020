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
export(String) var interact_action = "open_gate"

func _ready():
	EventBus.connect("open_gate", self, "on_gate_open")

func toggleGateOpen():
	if is_closed:
		gate_closed.hide()
		gate_open.show()
	else:
		gate_closed.show()
		gate_open.hide()

	is_closed = !is_closed
	set_collision_mask_bit(0, is_closed)

func on_gate_open(gate_name):
	toggleGateOpen()


