#tool
extends "res://scenes/character/character.gd"

#---------------------------Preview INFO------------------------------------#
#Draw line in game?
export (bool) var preview_ingame = false

#Preview info
export (int) var preview_line_lenght = 5 setget set_preview_line_lenght
export(int) var preview_line_count = 10 setget set_preview_line_count


func set_preview_line_lenght(value):
	preview_line_lenght = clamp(value,0,100)
	update()
#
func set_preview_line_count(value):
	preview_line_count = clamp(value,0,59)
	update()
#---------------------------END-Preview-INFO------------------------------------#


#---------------------------Var-Character-----------------------------------#
#Enum Anim

enum AnimationTree {IDLE, WALK, JUMP, ACTION, FALL, HIT, RECHARG}

var animE = AnimationTree.IDLE

export (NodePath) var anim_path
onready var anim = get_node(anim_path)

var move
var jump
var fall
var action
var hit

var dcm = null
#Direccion!
var input_direction = 0

var direction = 0

#Check if null object or instance freede
var wr
#esta en el aire? / is on air?
export (bool) var on_air = false

export (NodePath) var sprite_path
onready var sprite = get_node(sprite_path)

export (NodePath) var sprite_dcm_path
onready var sprite_dcm = get_node(sprite_dcm_path)

export (bool) var is_trigger = false

var trigger
var id_trigger
signal trigger_activated
var batery


export (NodePath) var raycast_d_path
onready var raycast_d = get_node(raycast_d_path)

export (NodePath) var raycast_h_path
onready var raycast_h = get_node(raycast_h_path)

export (NodePath) var raycast_r_path
onready var raycast_r = get_node(raycast_r_path)

export (NodePath) var raycast_l_path
onready var raycast_l = get_node(raycast_l_path)

#---------------------------Var-Character-----------------------------------#


#-----------------------------Var-DCM---------------------------------------#



#DCM Variables!!!!
#WORKS! Just don't touch
export (bool) var can_use_tp = true
#Bullet Scene
export (PackedScene) var dcm_scene
export (bool) var dcm_active = false
var dcm_pos = Vector2(0,0)
#Bullet Spawn
export (NodePath) var dcm_spawn_path
onready var dcm_spawn = get_node(dcm_spawn_path)

#Bullet gravity
export (int) var bullet_gravity = 5 setget set_bullet_gravity

#Bullet Speed
export (int) var bullet_speed = 8 setget set_bullet_speed

#Bullet Angle
export (float) var bullet_angle = 350 setget set_bullet_angle

#Directional force bullet
var directional_force = Vector2()

#shooting?

export (bool) var shooting = false setget set_shooting
#can shoot? / esto significa que si el jugador 
#ya tiro un dcm no podra tirar otro hasta teletransportarse

export (bool) var canShoot = true setget set_canShoot

var more_impulse = true
var recharg = false

func set_shooting(value):
	shooting = value

func set_canShoot(value):
	canShoot = value


#Direction of impulse dcm
export (float) var dcm_direction = 1



#-----------------------------Var-DCM---------------------------------------#


func set_bullet_angle(value):
	bullet_angle = clamp(value,0,359)
	update_directional_force()
	update()
	
func set_bullet_speed(value):
	bullet_speed = value
	update_directional_force()
	update()
	
func set_bullet_gravity(value):
	bullet_gravity = value
	update()

func update_directional_force():
	#print(dcm_direction)
	directional_force = Vector2(cos(bullet_angle*(PI/180))*dcm_direction, sin(bullet_angle*(PI/180))) * bullet_speed
	
	#var rad = deg2rad(bullet_angle)
	#directional_force = Vector2(cos(rad*dcm_direction),sin(rad))

#------------------------Empieza ready------------------------------
func _ready():
	#Update directional_force 
	update_directional_force()
	
	#Enable user Input
	set_process_input(true)
	
	#Enable process
	set_process(true)
	
	#Enable fix process
	set_fixed_process(true)
	
	
func desactive_dcm():
	dcm_active = false
	dcm = null

func _input(event):
	if(event.is_action_pressed("cancel") && dcm != null):
		restart_dcm()
		dcm.desactive()
		desactive_dcm()
		
	if(event.is_action_pressed("shoot") && canShoot && !dcm_active && !is_trigger):
		recharg = true
		preview_ingame = true
	if(event.is_action_pressed("shoot") && is_trigger):
		emit_signal("trigger_activated",id_trigger)
		animE = AnimationTree.ACTION
	if(event.is_action_released("shoot") && canShoot && !dcm_active && !is_trigger):
		recharg = false
		shooting = true
		canShoot = false
		preview_ingame = false
		can_use_tp = true
		sprite_dcm.hide()
		animE = AnimationTree.ACTION
	if(event.is_action_released("shoot") && dcm_active && !is_trigger):
		tp_to_dcm()
	

func _process(delta):
	if(shooting):
		fire_once()
	animation_handler()
	
func fire_once():
	shoot()
	shooting = false
	bullet_speed = 0.5
	update()
	update_directional_force()


func _fixed_process(delta):
	calculateMovement(delta)
	if(recharg):
		add_impulse_dmc()


func animation_handler():
	if(!hit):
		if(animE == AnimationTree.IDLE ):
			if(!anim.get_current_animation() == "idle"):
				anim.play("idle")
		elif(animE == AnimationTree.WALK):
			if(!anim.get_current_animation() == "walk"):
				anim.play("walk")
		elif(animE == AnimationTree.ACTION):
			if(!anim.get_current_animation() == "action"):
				anim.play("action")
		elif(animE == AnimationTree.JUMP):
			if(!anim.get_current_animation() == "jump"):
				anim.play("jump")
		elif(animE == AnimationTree.FALL):
			if(!anim.get_current_animation() == "fall"):
				anim.play("fall")
		elif(animE == AnimationTree.RECHARG):
			if(!anim.get_current_animation() == "recharg" && !trigger):
				anim.play("recharg")
	else:
		if(animE == AnimationTree.HIT):
			if(!anim.get_current_animation() == "hit" && !trigger):
				anim.play("hit")
func shoot():
	var bullet = dcm_scene.instance()
	bullet.set_global_pos(dcm_spawn.get_global_pos())
	bullet.shoot(directional_force, bullet_gravity)
	get_parent().add_child(bullet)
	bullet.connect("dcm_ready",self,"on_dcm_ready")
	dcm = bullet
	#bullet.connect("already_exist",self,"dcm_exist")
	dcm_pos = bullet.get_pos()
	
func add_impulse_dmc():
	if(animE != AnimationTree.WALK):
		animE = AnimationTree.RECHARG
	if(bullet_speed <= 7 && more_impulse):
		bullet_speed += 0.1
		update()
		update_directional_force()
	elif(bullet_speed > 6.8):
		more_impulse = false
	if(!more_impulse && bullet_speed > 0.2):
		bullet_speed -= 0.1
		update()
		update_directional_force()
	elif(bullet_speed <= 0.2):
		more_impulse = true

func calculateMovement(delta):
	var walk_left = Input.is_action_pressed("move_left")
	var walk_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	var shoot = Input.is_action_pressed("shoot")
	#mouse_pos = get_global_mouse_pos()
	if(jump && !on_air && !hit):
		speed_y = - JUMP_FORCE
		animE = AnimationTree.JUMP
		
	if(input_direction):
		direction = input_direction
	
	if(walk_left):
		dcm_direction = -1
		input_direction =-1
		set_scale(Vector2(get_scale().x * input_direction, get_scale().y))
		update_directional_force()
		update()
	
	elif(walk_right):
		dcm_direction = 1
		input_direction = 1
		set_scale(Vector2(get_scale().x * input_direction, get_scale().y))
		update_directional_force()
		update()
	
	else:
		input_direction = 0
		update_directional_force()
		update()
	  # MOVIMIENTO
	
	if (input_direction == - direction):
					speed_x /= 3
	if (input_direction):
					speed_x += ACCELERATION * delta
	else:
					speed_x -= DECELERATION * delta
	speed_x = clamp(speed_x, 0, MAX_SPEED)
	velocity = (Vector2(speed_x * delta * direction, speed_y * delta))
	var movement_remainded = move(velocity)
	if (is_colliding()):
		var normal = get_collision_normal()
		var final_movement = normal.slide(movement_remainded)
		speed_y = normal.slide(Vector2(0,speed_y)).y
		move(final_movement)
		
	else:
		on_air = true
		jump = true
	if(raycast_d.is_colliding()):
		on_air = false
		speed_y = 0
	if(raycast_h.is_colliding()):
		on_air = true
	if(raycast_l.is_colliding() && !raycast_d.is_colliding()):
		on_air = true
	if(raycast_r.is_colliding() && !raycast_d.is_colliding()):
		on_air = true
		
	if(velocity.x != 0 && !on_air && !hit):
		animE = AnimationTree.WALK
	elif(!on_air && !hit):
		animE = AnimationTree.IDLE
	
	if(on_air && velocity.y > 0 && !hit):
		animE = AnimationTree.FALL
func _draw():
	if(get_tree().is_editor_hint() or preview_ingame):
		var start_pos = get_node(dcm_spawn_path).get_pos()
		
		var prev_pos = start_pos
		
		for tick in range(1, preview_line_count):
			#randomize()
			#var color = Color(rand_range(0.3,1),rand_range(0.3,1),rand_range(0.3,1))
			var color = Color(1.0,0,0,1)
			tick *= preview_line_lenght
			
			var x = tick * directional_force.x * dcm_direction
			
			var y = calc_y_pos(tick)
			
			var next_pos = start_pos + Vector2(x,y)
			
			draw_line(prev_pos,next_pos,color)
			
			prev_pos = next_pos
		
		
func calc_y_pos(tick):
	if(tick != 0):
		return calc_y_pos(tick-1) + (directional_force.y + (tick/60.0) * bullet_gravity)
		
	else:
		return 0
		
		

######### Funcion que avisa cuando se puede teletrasportar 
######### ademas restaura las variables que eviten que dispares

func on_dcm_ready(pos,active,d):
	#dcm = d
	if(can_use_tp):
		can_use_tp = false
		if(!dcm_active):
			dcm_active = active
			restart_dcm()
		if(dcm_active):
			dcm_pos = pos
	if(!active):
		sprite_dcm.show()
		dcm = null

func tp_to_dcm():
	if(dcm != null):
		set_pos(Vector2(dcm_pos.x,dcm_pos.y - 15))
	
func _on_area_body_enter( body ):
	var groups = body.get_groups()
	if(groups.has("dcm")):
		body.free_dcm()
		if(dcm_active):
			dcm_active = false
			restart_dcm()
			#sprite_dcm.show()
			dcm = null
	if(groups.has("trigger")):
		is_trigger = true
		trigger = body
		id_trigger = body.id
		self.connect("trigger_activated",trigger,"active_trigger")
		#body.active_trigger()
	if(groups.has("mortal")):
		inst_death()
	
	if(groups.has("batery")):
		aply_batery(body)
	
	if(groups.has("door") && batery):
		body.get_parent().open_the_door()
		batery = false
		
	


func aply_batery( body ):
	if(!batery):
		batery = true
		body.queue_free()
	

func inst_death():
	hit = true
	animE = AnimationTree.HIT
	

func restart_dcm():
	#dcm = null
	sprite_dcm.show()
	canShoot = true
	dcm_direction = 1
	input_direction = 1
	set_scale(Vector2(get_scale().x * input_direction, get_scale().y))
	update_directional_force()
	update()
	

func _on_area_body_exit( body ):
	var groups = body.get_groups()
	if(groups.has("trigger")):
		is_trigger = false
		trigger = null
		id_trigger = null
	if(groups.has("mortal")):
		hit = false
