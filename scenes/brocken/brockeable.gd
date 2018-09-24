extends KinematicBody2D

export (float) var GRAVITY = 2000
export (float) var MAX_FALL_SPEED = 1000

export (NodePath) var timer_path
onready var timer = get_node(timer_path)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_timer_timeout():
	timer.stop()
	queue_free()


func _on_area_body_enter( body ):
	var groups = body.get_groups()
	if(groups.has("player")):
		timer.start()
