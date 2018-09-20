
extends KinematicBody2D

enum States {RIGTH, LEFT, UP, DOWN}
export var states = States.LEFT setget _set_states
export (float) var ACCELERATION = 100
export (float) var speed_x
export (float) var speed_y 
export (float) var MAX_SPEED = 100
export (bool) var STOP

export (NodePath) var anim_path
onready var anim = get_node(anim_path)

export (NodePath) var trigger_path
onready var trigger = get_node(trigger_path)
var velocity = Vector2()
var clawin = false
var col = false
signal claw_pos
signal limitSignal
signal downLimit
signal upclaw
var box

func _set_states(value):
	states = clamp(value, 0, States.size())
	
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("limitSignal",trigger,"is_stop")
	connect("downLimit",trigger,"is_limit")
	connect("upclaw",trigger,"up_claw")
	set_fixed_process(true)
	
func _fixed_process(delta):
	speed_x = clamp(speed_x, -MAX_SPEED, MAX_SPEED)
	speed_y = clamp(speed_y, -MAX_SPEED, MAX_SPEED)
	if(clawin):
		emit_signal("claw_pos",Vector2(get_pos().x,get_pos().y + 45))
	if(STOP):
		speed_x = 0
		speed_y = 0
	else:
		if(states == States.LEFT):
			speed_x -= ACCELERATION * delta 
		if(states == States.RIGTH):
			speed_x += ACCELERATION * delta
		if(states == States.DOWN):
			if(!clawin):
				speed_x = 0
				speed_y += ACCELERATION * delta
			else:
				clawin = false
				STOP = true
				box.clawOut()
				anim.play("abierto")
				emit_signal("downLimit",clawin)
				emit_signal("limitSignal",STOP)
		if(states == States.UP):
			emit_signal("upclaw",states)
			speed_x = 0
			speed_y -= ACCELERATION * delta
		

	velocity = (Vector2(speed_x * delta, speed_y * delta))
	var movement_remainded = move(velocity)
	if (is_colliding()):
		var normal = get_collision_normal()
		var final_movement = normal.slide(movement_remainded)
		speed_y = normal.slide(Vector2(0,speed_y)).y
		move(final_movement)


func _on_limit_body_enter( body ):
	var groups = body.get_groups()
	if(groups.has("tile")):
		STOP = true
		col = false
		speed_y = 0
		emit_signal("limitSignal",STOP)
		emit_signal("downLimit",col)

func _change_dir( state ):
	STOP = false
	speed_x = 0
	speed_y = 0
	states = state
	emit_signal("limitSignal",STOP)

func _on_boxclaw_body_enter( body ):
	var groups = body.get_groups()
	if(groups.has("movable")):
		box = body #Solo lo uso para despues soltarlo
		clawin = true
		body.clawin(Vector2(get_pos().x,get_pos().y + 30))
		speed_y = 0
		anim.play("cerrado")
		states = States.UP
		self.connect("claw_pos",body,"clawin")
	if(groups.has("tile")):
		speed_y = 0
		states = States.UP


func _on_limit_area_enter( area ):
	var groups = area.get_groups()
	if(groups.has("limit")):
		col = true
		emit_signal("downLimit",col)
		if(states == States.RIGTH):
			speed_x = 0
			STOP = true
			emit_signal("limitSignal",STOP)
			#states = States.LEFT
		elif(states == States.LEFT):
			speed_x = 0
			STOP = true
			emit_signal("limitSignal",STOP)
			#states = States.RIGTH
	if(groups.has("tile")):
		speed_y = 0


func _on_boxclaw_body_exit( body ):
	var groups = body.get_groups()
	if(groups.has("movable")):
		body.clawOut()


func _on_boxclaw_area_enter( area ):
	var groups = area.get_groups()
	if(groups.has("tile")):
		speed_y = 0
		states = States.UP


func _on_limit_area_exit( area ):
	var groups = area.get_groups()
	if(groups.has("limit")):
		col = false
