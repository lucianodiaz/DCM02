extends "res://scenes/level/level1-1.gd"

export (NodePath) var boss_path
onready var boss = get_node(boss_path)

export (NodePath) var trigger_boss
onready var t_boss = get_node(trigger_boss)

export (NodePath) var door_path
onready var door = get_node(door_path)

export (NodePath) var camera_path
onready var camera = get_node(camera_path)



export (NodePath) var anim_path
onready var anim = get_node(anim_path)


export (NodePath) var pos_path
onready var pos = get_node(pos_path)

export (NodePath) var derrumbe_path
onready var derrumbe = get_node(derrumbe_path)


export (AudioStream) var music_boss_path

export(NodePath) var t_music_boss_path
onready var t_music_boss = get_node(t_music_boss_path)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	global.current_scene = 3
	set_process(true)
	

func _process(delta):
	if(llego):
		if(transition.get_done()):
			global.next_chapter()
			global.change_scene()
	if(!boss.get_vivo()):
		if(!anim.get_current_animation() == "shake"):
			anim.play("shake")
			


func _on_empiezaBoss_body_enter( body ):
	door.close_door()
	boss._start()
	t_boss.queue_free()
	player.desactiveCamera()
	camera.make_current()

func _on_startMusic_body_enter( body ):
	music.set_loop(false)
	music.stop()
	music.set_stream(music_boss_path)
	music.set_loop(true)
	music.play()
	t_music_boss.queue_free()


func _on_shake_finished():
	if(anim.get_current_animation() == "shake"):
		derrumbe.aparecer(pos.get_global_pos())
		camera.clear_current()
		player.activeCamera()


func _on_final_body_enter( body ):
	var groups = body.get_groups()
	if(groups.has("player")):
		transition.set_init()
		llego = true


