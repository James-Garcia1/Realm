extends Node

func _ready():
	Global.currentRegionID = 0
	
	if (Global.gameStart):
		Global.gameStart = false
	else:
		$Player.set_position(Global.playerPositionLoad)
