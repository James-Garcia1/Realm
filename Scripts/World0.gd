extends Node

func _ready():
	if (Global.gameStart):
		Global.gameStart = false
	else:
		$Player.set_position(Global.playerPositionLoad)

func load_scene(playerPositon, player):
	Global.playerPositionLoad = playerPositon
	get_tree().change_scene("res://Scenes/World1.tscn")

func _on_LoadNextSceneArea_body_entered(body):
	load_scene(body.get_position(), body)
