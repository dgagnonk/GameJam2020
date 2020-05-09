extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("toggle_birds_eye", self, "on_toggle_birds_eye")
	

func on_toggle_birds_eye(birds_eye_on):
	if(birds_eye_on):
		current = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
