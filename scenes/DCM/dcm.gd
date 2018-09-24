extends KinematicBody2D


export (float) var MAX_FALL_SPEED = 50

#Gravity
var _gravity

#Movement
var _movement = Vector2()

#Bounce
var bounce = 0.4

var init_once = false
#Sprite
export(NodePath) var sprite_path
onready var sprite = get_node(sprite_path)

#raycast
export (NodePath) var raycast_path
onready var raycast = get_node(raycast_path)

#Particles
export (NodePath) var particles_path
onready var particles = get_node(particles_path)
#Timer
export (NodePath) var timer_path
onready var timer = get_node(timer_path)

export (NodePath) var timer_p_path
onready var timer_p = get_node(timer_p_path)

export (NodePath) var timer_q_path
onready var timer_q = get_node(timer_q_path)

#GROUND
export (bool) var is_ground = false

#Active
export (bool) var active = false

#Animation
export (NodePath) var animplayer_path
onready var animplayer = get_node(animplayer_path)

#Signal
signal dcm_ready
signal desactive_dcm

func shoot(directional_force, gravity):
	_movement = directional_force
	_gravity = gravity
	
	set_fixed_process(true)
	set_process(true)
	
func _process(delta):
	Is_grounded()
	#active_dcm()
	
func _fixed_process(delta):
	#Simulate gravity
	_movement.y +=delta * _gravity
	if(_movement.y >= MAX_FALL_SPEED):
		emit_signal("dcm_ready",get_pos(),active)
		queue_free()
	#If colliding whit something
	if(is_colliding()):
		#get node that we are colliding with 
		var entity = get_collider()
		
		#normal hit
		#Apply physics
		var normal = get_collision_normal()
		#apply bounce Forma manual
		#_movement = (_movement - 2 * _movement.dot(normal) * normal) * bounce
		
		#forma del engine
		_movement = normal.reflect(_movement) * bounce
	#Move 
	
	move(_movement)
	if(raycast.is_colliding()):
		is_ground = true
	else:
		is_ground = false
	
func Is_grounded():
	if(is_ground):
		if(!init_once):
			init_once = true
			timer.start()
	else:
		init_once = false
		timer.stop()
func active_dcm():
	#if(cooldown_ground >= time_cooldown_ground):
	animplayer.play("active")
	if(!active):
		active = true
	emit_signal("dcm_ready",get_pos(),active,self)
	
func free_dcm():
	if(active):
		active = false
		timer_q.start()

func _on_timer_timeout():
	active_dcm()


func _on_area_body_enter( body ):
	var groups = body.get_groups()
	if(groups.has("mortal")):
		emit_signal("desactive_dcm")
		desactive()
	
func desactive():
	timer_p.start()
	particles.set_emitting(true)
	sprite.hide()
	active = false
	set_fixed_process(false)
	emit_signal("dcm_ready",get_pos(),active,null)

func _on_timer_timeout_particles():
	timer_p.stop()
	queue_free()


func _on_timer_q_timeout():
	timer_q.stop()
	queue_free()
