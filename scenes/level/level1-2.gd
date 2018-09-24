extends "res://scenes/level/level1-1.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	global.current_scene = 2

	
func _on_final_body_enter( body ):
	var groups = body.get_groups()
	if(groups.has("player")):
		#global.next_level()
		#global.change_scene()
		transition.set_init()
		llego = true