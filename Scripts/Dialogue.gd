extends Control

var ID
var dialogueID
var dialogueState
var data

var startState #cause dialogue to play when first started
var choiceButtonPressed = -1

var imageType = ".jpg"
export(int) var WidthPerLine = 32
export(int) var choiceIndent = 20
export(int) var choiceStartLeadY = -50
export(float) var choiceLeadingScale = 1.5
export(float) var textSpeed = 0


func _ready():
	Global.Dialogue = self
	set_process(false)

#Signal From NPC from interact with NPC
#setID is sent from NPC and controls the loaded dialogue, sprites and
#dialogue state in the Global script 
#pauses all other nodes and starts process running
func _start(setID):
	show()
	ID = setID
	dialogueState = "dialogueState" + ID
	dialogueID = Global.get(dialogueState)
	
	get_tree().paused = true
	set_process(true)
	set_background()
	
	startState = true
	load_dialogue("res://Dialogue/data/" + ID + ".json")
	set_npc_name()
	set_npc_texture()

#Sets name above dialogue
func set_npc_name():
	$name.text = data[int(dialogueID)].NPC_Name

#sets texture depending on ID and emotion form data file
func set_npc_texture():
	$npc_sprite.set_texture(load("res://Sprites/" + ID + "/" + data[int(dialogueID)].Emotion + imageType))

#sets backgroud depending on ID
func set_background():
	$bg_sprite.set_texture(load("res://Sprites/" + ID + "/bg.png"))
	
#Sets the next dialogueID based off data
func set_next_dialog_ID(choiceNum):
	dialogueID = data[int(dialogueID)].Next_ID[choiceNum]
	
#sets the position of choices bases off the index of the choice and the position of dialogue
func set_choice_position(scaler, choiceNode):
	var choicePosition = $Tie.get_position()
	choicePosition.x += choiceIndent
	choicePosition.y += choiceStartLeadY
	choicePosition.y += ($Tie.get_label_lines() + (scaler * choiceLeadingScale)) * WidthPerLine
	choiceNode.set_position(choicePosition)

#Loads the dialagoue into data as dictionary
func load_dialogue(file_path):
	
	var file = File.new()
	if file.open(file_path, File.READ) != OK:
		return
	
	var dataParse = JSON.parse(file.get_as_text())
	if dataParse.error != OK:
		return
	data = dataParse.result

#startState causes the dialogue to play for the first call
#after the first call a dialogue choice must be made which corresponds to first condition
#Global dialogue state keeps track of dialogue IDs for next interaction
func play_dialogue():
	if (dialogueID != Global.get(dialogueState) || startState):
		startState = false
		$Tie.reset()
		$Tie.set_color(Color(1,1,1,1))
		$Tie.buff_text(data[int(dialogueID)].NPC_Dialogue, textSpeed)
		$Tie.set_state($Tie.STATE_OUTPUT)
		Global.set(dialogueState, dialogueID)

#returns index of player choice corresponding to key pressed, returns -1 for no choice
#uses size to only allow choices within array size
func player_choice_keys():
	if (Input.is_action_just_pressed("ui_select1") &&
	data[int(dialogueID)].Player_Choices.size() > 0):
		return 0
	elif (Input.is_action_just_pressed("ui_select2") &&
	data[int(dialogueID)].Player_Choices.size() > 1):
		return 1
	elif (Input.is_action_just_pressed("ui_select3") &&
	data[int(dialogueID)].Player_Choices.size() > 2):
		return 2
	elif (Input.is_action_just_pressed("ui_select4") &&
	data[int(dialogueID)].Player_Choices.size() > 3):
		return 3
	else:
		return -1

#turns off visibility for all choices
func choices_hide():
	for i in range(4):
		var choiceNode = get_node("choice" + str(i+1))
		choiceNode.hide()

#shows choices corresponding to data, checking number of choices and text of choices
func display_choices():
	choices_hide()
	var i = 1
	for choiceText in data[int(dialogueID)].Player_Choices:
		var choiceNode = get_node("choice" + str(i))
		choiceNode.show()
		choiceNode.text = str(i) + ". " + choiceText
		i += 1
		set_choice_position(i, choiceNode)

#Checks if current choice ends dialogue
func check_end(choiceNum):
	if (data[int(dialogueID)].End[choiceNum]):
		return true
	return false

#hides and resets dialogue and unpauses all other nodes
func end():
	set_process(false)
	choices_hide()
	get_tree().paused = false
	Global.set(dialogueState, dialogueID)
	choiceButtonPressed = -1
	$Tie.reset()
	hide()


#Prints the dialogue if dialogueID is different then global dialogueState or first time called
#Waits for player choice either key pressed or button clicked
#With player choice checks if ends dialogue or not and sets the next dialogueID
#If ends also sets global dialogueState to dialogueID
func _process(delta):
	play_dialogue()
	var choiceNum = player_choice_keys()
	if (choiceButtonPressed != -1):
		choiceNum = choiceButtonPressed
		choiceButtonPressed = -1
	if (choiceNum != -1) : 
		if (check_end(choiceNum)) :
			set_next_dialog_ID(choiceNum)
			end()
		else :
			set_next_dialog_ID(choiceNum)
			set_npc_texture()

#Used to display choices after all dialogue has been written, because the
#position of dialogue is based off the number of lines written
func _on_Tie_buff_end():
	display_choices()

#Next four functions control clicking dialogue choices
func _on_choice1_pressed():
	choiceButtonPressed = 0

func _on_choice2_pressed():
	choiceButtonPressed = 1

func _on_choice3_pressed():
	choiceButtonPressed = 2

func _on_choice4_pressed():
	choiceButtonPressed = 3
