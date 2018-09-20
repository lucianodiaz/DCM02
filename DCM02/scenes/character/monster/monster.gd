
extends "res://scenes/character/character.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
enum Direction { RIGTH , LEFT }
enum States {ATTACK , PATROL , PREPARE }
export (int) var dir = Direction.LEFT
var states = States.PATROL

var prepare = false
var collider = false

export (NodePath) var timer_path
onready var timer = get_node(timer_path)

export (NodePath) var sprite_path
onready var sprite = get_node(sprite_path)

export (NodePath) var anim_path
onready var anim = get_node(anim_path)

export (NodePath) var raycast_l_path
onready var raycast_l = get_node(raycast_l_path)

export (NodePath) var raycast_r_path
onready var raycast_r = get_node(raycast_r_path)

export (NodePath) var raycast_d_l_path
onready var raycast_d_l = get_node(raycast_d_l_path)

export (NodePath) var raycast_d_r_path
onready var raycast_d_r = get_node(raycast_d_r_path)

export (float) var speedx
#export (NodePath) var sprite_path
#onready var sprite = get_node(sprite_path)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	speed_x = speedx
	set_process(true)

func _process(delta):
	if(states == States.PATROL):
		patrol(delta)
	elif(states == States.ATTACK):
		attack(delta)
	elif(states == States.PREPARE):
		prepare(delta)
	
func _fixed_process(delta):
	#Ya se esta ejecutando la gravedad en el PADRE
	speed_x = clamp(speed_x, -MAX_SPEED, MAX_SPEED)
	velocity = (Vector2(speed_x * delta, speed_y * delta))
	
	var movement_remainded = move(velocity)
	
	if (is_colliding()):
		var normal = get_collision_normal()
		var final_movement = normal.slide(movement_remainded)
		speed_y = normal.slide(Vector2(0,speed_y)).y
		move(final_movement)


func patrol( delta ) :
	if(raycast_l.is_colliding()):
		dir = Direction.RIGTH
		sprite.set_flip_h(true)
	elif(raycast_r.is_colliding()):
		dir = Direction.LEFT
		sprite.set_flip_h(false)
	
	if(!raycast_d_l.is_colliding()):
		dir = Direction.RIGTH
		sprite.set_flip_h(true)
	elif(!raycast_d_r.is_colliding()):
		dir = Direction.LEFT
		sprite.set_flip_h(false)
	
	if(dir == Direction.RIGTH):
		speed_x += ACCELERATION * delta
	elif(dir == Direction.LEFT):
		speed_x -= ACCELERATION * delta
		

func attack(delta):
	speed_y = -JUMP_FORCE
	if(dir == Direction.RIGTH):
		speed_x += ACCELERATION * delta
	elif(dir == Direction.LEFT):
		speed_x -= ACCELERATION * delta
	states = States.PATROL
	collider = false
	prepare = false

func prepare( delta ):
	if(!prepare):
		print("prepare")
		prepare = true

func _on_time_attack_timeout():
	states = States.ATTACK
	prepare = false
	print("ataque")
	timer.stop()

func _on_attack_body_enter( body ):
	var groups = body.get_groups()
	if(groups.has("player") && !collider):
		speed_x = 0
		timer.start()
		states = States.PREPARE
		collider = true
	
