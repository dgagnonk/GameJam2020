extends Node

export(Array, String) var levels = []
export var progress = 0

var currentScene = null

func _ready():
	var root = get_tree().get_root()
	currentScene = root.get_child(root.get_child_count() - 1)
	EventBus.connect("victory",self,"on_victory")
	
func goto_scene(path):
	print("Attempting to load scene: " + path)
	call_deferred("_deferred_goto_scene", path)
	

func _deferred_goto_scene(path):
	currentScene.free()
	
	var s = ResourceLoader.load(path)
	
	currentScene = s.instance()
	
	get_tree().get_root().add_child(currentScene)
	get_tree().set_current_scene(currentScene)

func _input(event):
	if event.is_action_pressed("debug_next_level"):
		goto_next_level()

func goto_next_level():
	progress += 1
	Global.goto_scene(levels[progress])
	
func on_victory():
	yield(get_tree().create_timer(3.0), "timeout")
	goto_next_level()
