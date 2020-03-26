extends Node

func _ready():
	
	#sets tree spawn to false for all zones on game start
	print(1)
	var i = 0
	while (File.new().file_exists("res://Scenes/Region"+str(i)+".tscn")):
		# [wether trees spawn in region, #trees, sizes, coordinates, amount factor, size factor]
		Global.treeSpawn[i] = [false, 0, [], [], 10, 2]
		i += 1
	
func load_trees():
	var regionID = Global.currentRegionID
	var treeSpawnData = Global.treeSpawn[regionID]
	if treeSpawnData[0]:
		var treeNode = load("res://Scenes/Tree.tscn")
		var regionNode = get_node("Region" + str(regionID))
		for i in range(treeSpawnData[1]):
			var currentTreeNode = treeNode.instance()
			regionNode.add_child(currentTreeNode)
			currentTreeNode.set_scale(Vector2(treeSpawnData[2][i],treeSpawnData[2][i]))
			currentTreeNode.set_position(treeSpawnData[3][i])

func load_scene(playerPositon, nextRegionID):
	Global.playerPositionLoad = playerPositon
	
	# Remove the current region
	var region = get_node("Region" + str(Global.currentRegionID))
	region.queue_free()
	
	# Add the next region
	self.add_child(load("res://Scenes/Region" + str(nextRegionID)+ ".tscn").instance())
	
	load_trees()

func _on_LoadNextSceneArea_body_entered(body, ID):
	load_scene(body.get_position(), ID)


func _on_Control_LoadTrees():
	load_trees()
