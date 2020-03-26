extends Area2D

var ID = "02"
var font
var canInteract = false
signal interact

func _ready():
	connect("body_entered",self,"_dialogue_prompt")
	connect("body_exited",self,"_dialogue_end_prompt")
	connect("interact", get_parent().get_parent().get_node("CanvasLayer").get_node("Dialogue") , "_start")

#Show prompt when near npc
func _dialogue_prompt(body):
	if body.name == "Player":
		get_node("Interact-Dialogue").visible = true
		canInteract = true

#Remove prompt when not near npc
func _dialogue_end_prompt(body):
	if body.name == "Player":
		$"Interact-Dialogue".hide()
		canInteract = false

#If interacted with activates Dialogue state which pauses all but Dialogue script
func _process(delta):
	if (canInteract && Input.is_action_just_pressed("ui_interact")):
		Global.Dialogue.show()
		emit_signal("interact", ID)
