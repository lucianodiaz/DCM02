tool
extends KinematicBody2D
#CHARACTER ES EL PADRE DE TODOS LAS ENTIDADES PERSONAJES COMO EL JUGADOR Y LOS ENEMIGOS
#HAGO ESTO PARA NO TENER QUE REPETIR LAS VARIABLES DE MOVIMIENTO

export (float) var MAX_SPEED = 600
export (float) var ACCELERATION = 1000
export (float) var DECELERATION = 2000
export (float) var JUMP_FORCE = 800 setget _set_jump_speed
export (float) var GRAVITY = 2000
export (float) var MAX_FALL_SPEED = 1000

var velocity = Vector2()
var speed_x = 0
var speed_y = 0


var vivo = true

func _ready():
	if get_tree().is_editor_hint(): #para que haga draw sólo en tool mode
		update()
	else:
		set_fixed_process(true)
		update()
	
	
func _set_jump_speed(jf):
	JUMP_FORCE = jf
	update()
		
		
func _draw():
	if get_tree().is_editor_hint():
		draw_line(Vector2(),Vector2(0,-JUMP_FORCE*0.2),Color(1,0,0),3)