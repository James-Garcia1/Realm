extends Area2D

var ID = "01"
var font
var nearBy = false
var startLength = Global.bridgeLength01
var length = Global.bridgeLength01
var maxLength = Global.bridgeMaxLength01
signal interact

var bridgeStates = []

var imgType = ".png"
export(int) var woodRequired = 10

func _ready():
	connect("body_entered",self,"_dialogue_prompt")
	connect("body_exited",self,"_dialogue_end_prompt")
	
	for i in range(maxLength - startLength + 1):
		bridgeStates.push_back(load("res://Sprites/Bridge/bridge" + str(length+i) + imgType))
	
	set_bridge_sprite()


#checks to make sure player has enough resources
func resource_check():
	if (Global.playerWood >= woodRequired):
		return true
	return false

func increase_bridge_length():
	spend_resource()
	length += 1
	set_bridge_sprite()

func not_max_length():
	if (length == maxLength):
		return false
	return true

func spend_resource():
	Global.playerWood -= woodRequired
	
func set_bridge_sprite():
	$"../Sprite".set_texture(bridgeStates[length-startLength])

	
func can_increase_length():
	if resource_check() && not_max_length():
		return true
	return false

func set_dialogue_text():
	if can_increase_length():
		#E to Build (Length/MaxLength) (10 Wood)
		$"Interact-Dialogue".text = "E to Build (" + str(length) + "/" + str(maxLength) + ") (10 wood)"
		$"Interact-Dialogue".visible = true
	elif not_max_length():
		#Not Enough Wood (Length/MaxLength) (10 Wood)
		$"Interact-Dialogue".text = "Not Enough Wood (" + str(length) + "/" + str(maxLength) + ") (10 wood)"
		$"Interact-Dialogue".visible = true
	else:
		$"Interact-Dialogue".visible = false

func Global_update():
	Global.bridgeLength01 = length

#Show prompt when near npc
func _dialogue_prompt(body):
	if body.name == "Player":
		set_dialogue_text()
		nearBy = true

#Remove prompt when not near npc
func _dialogue_end_prompt(body):
	if body.name == "Player":
		$"Interact-Dialogue".hide()
		nearBy = false

#If interacted with activates Dialogue state which pauses all but Dialogue script
func _process(delta):
	if (nearBy && Input.is_action_just_pressed("ui_interact")):
		if (can_increase_length()):
			increase_bridge_length()
			set_dialogue_text()
			Global_update()

