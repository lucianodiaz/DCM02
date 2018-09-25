extends Control
export (NodePath) var bvida_path
onready var bvida = get_node(bvida_path)

export (NodePath) var dcm_path
onready var dcm = get_node(dcm_path)

export (NodePath) var anim_dcm_path
onready var anim_dcm = get_node(anim_dcm_path)

export (NodePath) var anim_bvida_path
onready var anim_bvida = get_node(anim_bvida_path)

export (NodePath) var batery_path
onready var batery = get_node(batery_path)



export (NodePath) var player_path
onready var player = get_node(player_path)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	
	
func _process(delta):
	anim_bvida.play(str(player.life))
	if(player.batery):
		batery.show()
	elif(!player.batery):
		batery.hide()
	if(player.dcm_active):
		anim_dcm.play("active")
	elif(!player.dcm_active):
		anim_dcm.play("desactive")
