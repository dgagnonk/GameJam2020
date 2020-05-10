extends Node2D





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = $Timer
	timer.connect("timeout", self, "return_to_main")
	timer.set_wait_time(10)
	timer.start()

func return_to_main():
	Global.goto_scene("res://src/Main/GameScene.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
