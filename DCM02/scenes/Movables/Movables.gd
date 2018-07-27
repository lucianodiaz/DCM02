extends KinematicBody2D

export (float) var GRAVITY = 500
export (float) var MAX_FALL_SPEED = 500
export (float) var MAX_SPEED = 600
export (float) var ACCELERATION = 1000
export (float) var DECELERATION = 2000


var move = false
var m_dir = 0
enum direction { RIGHT , LEFT}

var dir = direction.RIGHT 


var posIni = Vector2()
var visto = false


var velocity = Vector2()
var speed_x = 0
var speed_y = 0
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	posIni = get_pos()
	set_fixed_process(true)

func _fixed_process(delta):
	
	
	
	if(move):
		speed_x += ACCELERATION * delta
	else:
		speed_x -= DECELERATION * delta
		
	speed_x = clamp(speed_x,0,MAX_SPEED)
	speed_y += GRAVITY * delta
	
	if(speed_y > MAX_FALL_SPEED):
		speed_y = MAX_FALL_SPEED
			
			
	velocity = (Vector2(speed_x * delta * m_dir,speed_y * delta))
	var movement_remainded = move(velocity)
	if(is_colliding()):
		var normal = get_collision_normal()
		var final_movement = normal.slide(movement_remainded)
		speed_y = normal.slide(Vector2(0,speed_y)).y
		move(final_movement)

func _on_area_body_enter( body ):
	var groups = body.get_groups()
	if(groups.has("player")):
		if(body.get_pos().x > get_pos().x):
			move = true
			m_dir = -1
			dir = direction.LEFT
		elif(body.get_pos().x < get_pos().x):
			move = true
			m_dir = 1
			dir = direction.RIGHT


func _on_area_body_exit( body ):
	move = false
	m_dir = 0


func _on_visibilidad_exit_screen():
	if(visto):
		set_pos(posIni)


func _on_visibilidad_enter_screen():
	visto = true
