extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (NodePath) var transition_path
onready var transition = get_node(transition_path)

export (NodePath) var player_path
onready var player = get_node(player_path)

export (NodePath) var music_path
onready var music = get_node(music_path)

var llego = false
func _ready():
	music.play()
	set_process(true)
	global.current_scene = 1
	

func _process(delta):
	if(llego):
		if(transition.get_done()):
			global.position = null
			global.batery = null
			global.next_level()
			global.change_scene()
			
	if(player.dead):
		transition.set_init()
		if(transition.get_done()):
			global.change_scene()

func _on_next_level_body_enter( body ):
	var groups = body.get_groups()
	if(groups.has("player")):
		transition.set_init()
		llego = true
		
		
