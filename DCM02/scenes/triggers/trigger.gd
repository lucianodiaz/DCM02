tool
extends KinematicBody2D

export (bool) var open = false setget active_open
export (float) var cooldown = 0.0
export (float) var limit_cooldown = 5
export (int) var id

var once_call = true
var once_call_2 = true

export (NodePath) var door_path


export (NodePath) var label_path
onready var label = get_node(label_path)

export (NodePath) var animplayer_path
onready var animplayer = get_node(animplayer_path)

signal is_actived 
signal is_inactived

func active_open(value):
	emit_signal("is_actived")
	

func _ready():
	pass

func active_trigger(var t_id):
	if(!open && id == t_id):
		open = true
		var door = get_node(door_path)
		self.connect("is_actived", door, "open_the_door")
		self.connect("is_inactived",door,"no_open_door")
		animplayer.play("active")
		set_process(true)
	

func _process(delta):
	if(open):
		cooldown += 0.02
		if(once_call):
			emit_signal("is_actived")
			once_call = false
			once_call_2 = true
	desactive()
	label.set_text(str(int(cooldown)))

func desactive():
	if(cooldown > limit_cooldown):
		open = false
		cooldown = 0.0
		animplayer.play("inactive")
		if(once_call_2):
			emit_signal("is_inactived")
			once_call_2 = false
			once_call = true
		