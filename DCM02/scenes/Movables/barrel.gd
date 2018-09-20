extends "res://scenes/Movables/Movables.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_damage_body_enter( body ):
	var groups = body.get_groups()
	if(groups.has("enemigo")):
		queue_free()
		body.queue_free()
