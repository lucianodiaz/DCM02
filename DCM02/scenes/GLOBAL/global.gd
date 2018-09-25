extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var current_scene = 1
var current_chapter = 1
var scene_to_charge
var position = null
var batery = false
#onready var scene_to_charge = preload("res://scenes/level/level"+str(current_chapter)+"-"+str(current_scene)+".tscn")
func _ready():
	pass
func next_level():
	#scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	current_scene +=1
	
func next_chapter():
	current_scene =1
	current_chapter +=1
func back_menu():
	get_tree().change_scene("res://scenes/level/menu.tscn")
func change_scene():
	get_tree().change_scene(("res://scenes/level/level"+str(current_chapter)+"-"+str(current_scene)+".tscn"))