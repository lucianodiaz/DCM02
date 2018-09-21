extends "res://scenes/character/monster/monster.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (NodePath) var timer_at_path
onready var timer_at = get_node(timer_at_path)

export (NodePath) var point2d_path
onready var point = get_node(point2d_path)

export (PackedScene) var baba

var playingAttack = false
var can_shoot = true
func _ready():
	set_fixed_process(true)
	set_process(true)
	
func _process(delta):
	animation_handler()
	
	
func animation_handler():
	if(states == States.PATROL):
		if(!anim.get_current_animation() == "move"):
			anim.play("move")
	elif(states == States.ATTACK):
		if(!anim.get_current_animation() == "attack"):
			anim.play("attack")
	elif(states == States.PREPARE):
		if(!anim.get_current_animation() == "down"):
			anim.play("down")
		if(anim.get_current_animation() == "down" && !anim.is_playing()):
			states = States.PATROL
	
func _fixed_process(delta):
	if(states == States.PATROL):
		patrol(delta)
		
	elif(states == States.ATTACK):
		attack(delta)


func _on_timer_timeout():
	states = States.PREPARE
	collider = false
	timer.stop()

func attack(delta):
	if(can_shoot):
		shoot()
		can_shoot = false
	timer_at.start()
	#shoot()

func prepare(delta):
	pass

func shoot():
	var bullet = baba.instance()
	bullet.set_global_pos(point.get_global_pos())
	get_parent().add_child(bullet)
	
func _on_attack_body_enter( body ):
	var groups = body.get_groups()
	if(groups.has("player") && !collider):
		speed_x = 0
		states = States.ATTACK
		collider = true
	


func _on_attack_body_exit( body ):
	var groups = body.get_groups()
	if(groups.has("player")):
		timer.start()

func _on_timer_at_timeout():
	can_shoot = true
	timer_at.stop()
	
