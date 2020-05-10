extends Node


signal reverse_gravity(orientation)
signal goal(at_goal, player)
signal victory()
signal toggle_birds_eye(toggle_on)

onready var players_at_goal = []

signal toggle_gate_open(gate_name)
signal force_gate_close(gate_name)
signal force_gate_open(gate_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("goal",self,"on_goal")
	
func on_goal(at_goal, player):
	if at_goal:
		if ! player in players_at_goal:
			players_at_goal.append(player)
			if len(players_at_goal) > 1:
				emit_signal("victory")
	else:
		players_at_goal.erase(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
