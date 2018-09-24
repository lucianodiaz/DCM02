extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (NodePath) var timer_path
onready var timer = get_node(timer_path)

func _ready():
	timer.start()


func _on_timer_timeout():
	timer.stop()
	global.back_menu()
