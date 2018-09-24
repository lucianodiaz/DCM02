#tool
extends KinematicBody2D

export (float) var GRAVITY = 500
export (float) var MAX_FALL_SPEED = 500

var velocity = Vector2()

var speed_y = 0
var apear = false

func _ready():
	hide()
	
func aparecer(pos):
	set_global_pos( pos)
	show()
	set_fixed_process(true)

func _fixed_process(delta):
	speed_y += GRAVITY * delta
	if(speed_y > MAX_FALL_SPEED):
		speed_y = MAX_FALL_SPEED
	velocity = (Vector2(0,speed_y * delta))
	var movement_remainded = move(velocity)

func _on_area_body_enter( body ):
	var groups = body.get_groups()
	if(groups.has("boss")):
		body.desaparecer()
