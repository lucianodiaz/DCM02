extends ColorFrame

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var cutoff = 0.0
var material 
export (NodePath) var transition_path
onready var transition = get_node(transition_path)
var init = false
var finish = false
var done = false
export (float) var velocity = 0.01
func _ready():
	hide()
	set_process(true)
	material = transition.get_material()

func set_init():
	init = true

func set_finish():
	finish = true

func get_done():
	return done
func _process(delta):
	if(init):
		show()
		if(cutoff <= 1):
			cutoff += velocity
			material.set_shader_param("cutoff",cutoff)
		elif(cutoff > 1):
			cutoff = 1
			init = false
			done = true
	elif(!init):
		hide()
