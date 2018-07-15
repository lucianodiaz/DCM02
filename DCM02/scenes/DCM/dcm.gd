extends KinematicBody2D

#Gravity
var _gravity

#Movement
var _movement = Vector2()

#Bounce
var bounce = 0.4


#raycast
export (NodePath) var raycast_path
onready var raycast = get_node(raycast_path)

#GROUND
export (bool) var is_ground = false
export (float) var cooldown_ground = 0.0
var time_cooldown_ground = 8
#Active
export (bool) var active = false

#Animation
export (NodePath) var animplayer_path
onready var animplayer = get_node(animplayer_path)

#Signal
signal dcm_ready

func shoot(directional_force, gravity):
	_movement = directional_force
	_gravity = gravity
	
	set_fixed_process(true)
	set_process(true)
	
func _process(delta):
	Is_grounded()
	active_dcm()
func _fixed_process(delta):
	#Simulate gravity
	_movement.y +=delta * _gravity
	
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
	#if(is_colliding()):
#		if(_movement.x == 0):
#			animplayer.play("active")
#			if(!active):
#				active = true
#			emit_signal("dcm_ready",get_pos(),active)
#		
#		
#	else:
#		animplayer.play("inactive")
	
func Is_grounded():
	if(is_ground):
		cooldown_ground += 0.1
	else:
		cooldown_ground = 0
func active_dcm():
	if(cooldown_ground >= time_cooldown_ground):
		animplayer.play("active")
		if(!active):
			active = true
		emit_signal("dcm_ready",get_pos(),active)
	
func free_dcm():
	if(active):
		active = false
		queue_free()