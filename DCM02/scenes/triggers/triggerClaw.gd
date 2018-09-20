extends KinematicBody2D

export (int) var id = 0

export (NodePath) var claw_path
onready var claw = get_node(claw_path)
export (NodePath) var anim_path
onready var anim = get_node(anim_path)

export (int) var dir
var stop
var limit
var lastDir = null
signal clawMove
func _ready():
	# Called every time the node is added to the scene.
	# Initialization heree
	connect("clawMove",claw,"_change_dir")
	set_process(true)

func _process(delta):
	if(stop):
		anim.play("stop")
	else:
		anim.play(str(dir))


func is_stop( value ):
	stop = value

func is_limit( value ):
	limit = value
func up_claw ( value):
	dir = value

func active_trigger(var t_id):
	if(!limit):
		if(lastDir != null && id == t_id):
			dir = lastDir
		if(dir == 0):
			dir = 1
			emit_signal("clawMove",dir)
		elif(dir == 1):
			dir = 0
			emit_signal("clawMove",dir)
	else:
		if(dir <= 1):
			lastDir = dir
		dir = 3
		emit_signal("clawMove",dir)