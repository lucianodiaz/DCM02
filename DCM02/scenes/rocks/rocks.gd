#tool
extends KinematicBody2D

export (float) var GRAVITY = 500
export (float) var MAX_FALL_SPEED = 500

var velocity = Vector2()

var speed_y = 0
var init_pos 

export (NodePath) var timer_path
onready var timer = get_node(timer_path)

export (NodePath) var sprite_path
onready var sprite = get_node(sprite_path)

func _ready():
	init_pos = get_pos()
	set_fixed_process(true)
	

func _fixed_process(delta):
	speed_y += GRAVITY * delta
	if(speed_y > MAX_FALL_SPEED):
		speed_y = MAX_FALL_SPEED
	velocity = (Vector2(0,speed_y * delta))
	var movement_remainded = move(velocity)


func _on_collision_queue_body_enter( body ):
	var groups = body.get_groups()
	if(!groups.has("mortal") && !groups.has("dcm") && !groups.has("player") && !groups.has("enemigo")):
		set_pos(init_pos)
		set_fixed_process(false)
		timer.start()
		#sprite.hide()


func _on_timer_timeout():
	
	speed_y = 0
	set_fixed_process(true)
	sprite.show()
	timer.stop()
