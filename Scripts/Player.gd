extends KinematicBody2D

var MAX_SPEED = 500
var ACCELERATION = 2000
var motion = Vector2.ZERO
#Interacting with tree, tree index, Tree Node
var treeInteract = [false, 0, false, null]
var regionTreeData

signal FinishTree

func _ready():
	connect("FinishTree", get_parent().get_parent().get_node("Control"), "_remove_tree")

func _physics_process(delta):
	var axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friciton(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
	if treeInteract[0]:
		motion = Vector2.ZERO
		take_tree_energy()
	elif treeInteract[2]:
		motion = Vector2.ZERO
		finish_tree_energy()
	else:
		motion = move_and_slide(motion)

func take_tree_energy():
	if (Input.is_action_pressed("ui_interact")):
		if (regionTreeData[6][treeInteract[1]] > 0):
			var decreasedEnergy = 1
			regionTreeData[6][treeInteract[1]] -= (decreasedEnergy)
			increase_player_wood(decreasedEnergy)
		else:
			treeInteract[0] = false
	else:
		treeInteract[0] = false

func finish_tree_energy():
	increase_player_wood(Global.energyFactor * regionTreeData[2][treeInteract[1]] * 2)
	emit_signal("FinishTree", treeInteract[1], treeInteract[3])
	treeInteract[2] = false

func increase_player_wood(energy):
	Global.playerWood += int(energy)

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis.normalized();

func apply_friciton(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)

func find_tree_index(numTrees, treeCoordinates, treeNodeCoordinates):
	for i in range(numTrees):
		if treeCoordinates[i] == treeNodeCoordinates:
			return i
	print("Couldn't 2Find Inex")

#Signal from Tree if tree is being finished sets treeInteract[2] to true otherwise sets treeInteract[1]
#to true
func _tree_interact(treeNode):
	regionTreeData = Global.treeSpawn[Global.currentRegionID]
	var treeCoordinate = treeNode.get_global_position()
	treeInteract[1] = find_tree_index(regionTreeData[1], regionTreeData[3], treeCoordinate)
	if (regionTreeData[6][treeInteract[1]] > 0):
		treeInteract[0] = true
	else:
		treeInteract[2] = true
		treeInteract[3] = treeNode
