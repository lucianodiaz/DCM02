extends "res://scenes/character/monster/monster.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var playingAttack = false
func _ready():
	anim.play("move")
	set_fixed_process(true)
	set_process(true)
	
func _process(delta):
	pass
func _fixed_process(delta):
	if(states == States.PATROL):
		patrol(delta)
		if(!anim.get_current_animation() == "move"):
			anim.play("move")
	elif(states == States.ATTACK):
		attack(delta)


func _on_timer_timeout():
	states = States.PREPARE
	collider = false
	timer.stop()

func attack(delta):
	if(!anim.get_current_animation() == "attack"):
		anim.play("attack")

func prepare(delta):
	if(!anim.get_current_animation() == "down"):
		anim.play("down")
	if(anim.get_current_animation() == "down" && !anim.is_playing()):
		states = States.PATROL
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