extends Node

func _ready():
	Global.currentRegionID = 1
	$Player.set_position(Global.playerPositionLoad) 
