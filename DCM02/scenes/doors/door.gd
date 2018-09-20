tool
extends "res://scenes/doors/door_father.gd"


func _ready():
	set_process(true)
	
func _process(delta):
	if(get_tree().is_editor_hint()):
		return
	if(current_keys >= cant_keys && !open):
		animplayer.play(str(current_keys))
		open = true
	elif(current_keys <= cant_keys && !open):
		animplayer.play(str(current_keys))
	if(open):
		if(!(animplayer.get_current_animation() == str(cant_keys))):
			animplayer.play(str(current_keys))
		collision.set_trigger(true)
