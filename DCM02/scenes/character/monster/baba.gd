extends KinematicBody2D

var _gravity = 4
var _movement = Vector2()

var collision = false
var damage = 1

export(NodePath) var collision_path
onready var coll = get_node(collision_path)

export (NodePath) var anim_path
onready var anim = get_node(anim_path)

func _ready():
	anim.play("idle")
	set_fixed_process(true)
	set_process(true)
func _process(delta):
	if(collision):
		if(anim.get_current_animation() != "dead"):
			
			anim.play("dead")

func _fixed_process(delta):
	_movement.y +=delta * _gravity
	move(_movement)

func get_damage():
	return damage
func _on_anim_finished():
	if(anim.get_current_animation() == "dead"):
		queue_free()

func _on_damage_body_enter( body ):
	
	var groups = body.get_groups()
	
	if(!groups.has("enemigo")):
		if(groups.has("player")):
			#set_fixed_process(false)
			queue_free()
		elif(groups.has("tile") or groups.has("movable")):
			_gravity = 0
			collision = true
	