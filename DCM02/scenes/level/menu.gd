extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (NodePath) var selector_path
onready var selector = get_node(selector_path)

export (NodePath) var jugar_path
onready var jugar = get_node(jugar_path)

export (NodePath) var salir_path
onready var salir = get_node(salir_path)
export (int) var offsetSalir = 30
export (int) var offsetJugar = 30
var index = 1


export (NodePath) var transition_path
onready var transition = get_node(transition_path)
func _ready():
	# Called every time the node is added to the scene.
	set_process_input(true)
	set_process(true)
	
func _input(event):
	if(event.is_action_pressed("ui_up") ):
		if(index < 1):
			index += 1
		elif(index >= 1):
			index = 0

	if(event.is_action_pressed("ui_down")):
		if(index <= 0):
			index = 1
		elif(index >= 1):
			index = 0
			
	if(event.is_action_pressed("ui_accept")):
		if(index == 0):
			salir()
		elif(index == 1):
			jugar()


func _process(delta):
	if(transition.get_done()):
		global.change_scene()
	if(index == 0):
		selector.set_pos(Vector2(selector.get_pos().x ,(salir.get_texture().get_data().get_height() + selector.get_texture().get_data().get_height()+offsetSalir)))
	if(index == 1):
		selector.set_pos(Vector2(selector.get_pos().x ,(jugar.get_texture().get_data().get_height() - selector.get_texture().get_data().get_height()+offsetJugar)))
func jugar():
	transition.set_init()
	
	

func salir():
	get_tree().quit()