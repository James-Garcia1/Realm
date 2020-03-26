extends Node

signal LoadTrees

var canSpawn
var rng = RandomNumberGenerator.new()

func _ready():
	canSpawn = true

func random_num_trees(amountFactor):
	return rng.randi_range(0, 1 * amountFactor)

func random_size_trees(numTrees, sizeFactor):
	var treeSizes = []
	for i in range(numTrees):
		treeSizes.push_back(rng.randf_range(0.5, 1 * sizeFactor))
	return treeSizes
	
func coordinates_trees(numTrees, region):
	var treeCoordinates = []
	for i in range(numTrees):
		var regionSpawnCoordinates = Global.get("treeSpawnCoordinates" + str(region))
		treeCoordinates.push_back(regionSpawnCoordinates.back())
		regionSpawnCoordinates.pop_back()
	return treeCoordinates

func spawn_trees():
	rng.randomize()
	for region in Global.treeSpawn.keys():
		var regionTreeData = Global.treeSpawn[region]
		if regionTreeData[0]:
			regionTreeData[1] = random_num_trees(regionTreeData[4])
			regionTreeData[2] = random_size_trees(regionTreeData[1], regionTreeData[5])
			regionTreeData[3] = coordinates_trees(regionTreeData[1], region)

func _process(delta):
	if Global.dialogueState02 == "004" && canSpawn:
		canSpawn = false
		Global.treeSpawn[0][0] = true
		spawn_trees()
		emit_signal("LoadTrees")
