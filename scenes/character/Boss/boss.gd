extends Node

export (float) var MAX_SPEED = 600
export (float) var ACCELERATION = 1000
export (float) var DECELERATION = 2000
export (float) var JUMP_FORCE = 800 
export (float) var GRAVITY = 2000
export (float) var MAX_FALL_SPEED = 1000

var velocity = Vector2()
var speed_x = 0
var speed_y = 0
var damage = 1
enum Direction { RIGTH , LEFT }
enum States {ATTACK , PATROL , PREPARE }
export (int) var dir = Direction.LEFT
var states = States.PATROL
export (int) var life = 10
export (NodePath) var raycast_l_path
onready var raycast_l = get_node(raycast_l_path)

export (NodePath) var raycast_r_path
onready var raycast_r = get_node(raycast_r_path)

export (NodePath) var sprite_path
onready var sprite = get_node(sprite_path)

export (NodePath) var t_path
onready var t = get_node(t_path)

export (NodePath) var label_path
onready var label = get_node(label_path)


export (NodePath) var col_path
onready var col = get_node(col_path)


export (NodePath) var sound_path
onready var sound = get_node(sound_path)


var vivo = true

signal choque

export (float) var speedx = 100
var maxlife

func _start():
	maxlife = life
	speed_x = speedx
	sound.play("roar")
	set_fixed_process(true)
	set_process(true)

func get_vivo():
	return vivo
func _process(delta):
	if(vivo):
		if(states == States.PATROL):
			patrol(delta)
		elif(states == States.ATTACK):
			attack(delta)
		elif(states == States.PREPARE):
			prepare(delta)
	#label.set_text(str(life))
	if(life <= maxlife/2 && vivo):
		rage_mode()
	if(life <= 0):
		vivo = false
	
func desaparecer():
	hide()
	col.queue_free()
	sound.play("death")

func rage_mode():
	MAX_SPEED = 450
	ACCELERATION = 1000
func _fixed_process(delta):
	speed_y += GRAVITY * delta
	if(speed_y > MAX_FALL_SPEED):
		speed_y = MAX_FALL_SPEED
		
	if(dir == Direction.RIGTH):
		speed_x += ACCELERATION * delta
	elif(dir == Direction.LEFT):
		speed_x -= ACCELERATION * delta
	
	speed_x = clamp(speed_x, -MAX_SPEED, MAX_SPEED)
	velocity = (Vector2(speed_x * delta, speed_y * delta))
	
	var movement_remainded = move(velocity)
	
	if (is_colliding()):
		var normal = get_collision_normal()
		var final_movement = normal.slide(movement_remainded)
		speed_y = normal.slide(Vector2(0,speed_y)).y
		move(final_movement)
		
		
func get_damage():
	return damage
	
func patrol( delta ) :
	if(raycast_l.is_colliding()):
		dir = Direction.RIGTH
		sprite.set_flip_h(false)
		t.start()
	elif(raycast_r.is_colliding()):
		dir = Direction.LEFT
		sprite.set_flip_h(true)
		t.start()

func attack(delta):
	pass

func prepare( delta ):
	pass

func _on_t_life_timeout():
	t.stop()
	if(life > 0):
		life -=1
