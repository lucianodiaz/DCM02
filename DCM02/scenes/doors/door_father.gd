tool
extends Sprite

#export (NodePath) var keys = []
export (NodePath) var animplayer_path
onready var animplayer = get_node(animplayer_path)


export(NodePath) var kinematic_path
onready var kinematic = get_node(kinematic_path)

export(NodePath) var collision_path
onready var collision = get_node(collision_path)


export (int) var cant_keys = 2 setget set_cantkeys
export (int) var current_keys = 0 setget set_currentkeys
export (bool) var open = false


func set_cantkeys(value):
	cant_keys = clamp(value,0,5)

func set_currentkeys(value):
	current_keys = clamp(value,0,cant_keys)
	
func open_the_door():
	if(!open):
		current_keys += 1

func no_open_door():
	if(!open):
		current_keys -=1