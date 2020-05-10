extends Node2D
#(Array, PackedScene)
export(Array, String) var levels = []
export var progress = 0

#load level (instantiate level)
#advance through levels

#abilty to reload level

# Called when the node enters the scene tree for the first time.
func _ready():
	#Load data into global script
	Global.levels = levels
	


func _on_Button_pressed():
	Global.goto_scene(Global.levels[0])
