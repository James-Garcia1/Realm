extends Area2D

var index
var canInteract = false
signal interact

func _ready():
	connect("body_entered",self,"_interact_prompt")
	connect("body_exited",self,"_interact_end_prompt")
	connect("interact", get_parent().get_parent().get_node("Player"), "_tree_interact")
	index = Global.currentTreeIndex
	print(index)

#Show prompt when near npc
func _interact_prompt(body):
	if body.name == "Player":
		$"InteractDialogue".show()
		canInteract = true

#Remove prompt when not near npc
func _interact_end_prompt(body):
	if body.name == "Player":
		$"InteractDialogue".hide()
		canInteract = false

#If interacted with activates interact state which pauses all but interact script
func _process(delta):
	if (canInteract && Input.is_action_just_pressed("ui_interact")):
		emit_signal("interact", self)
