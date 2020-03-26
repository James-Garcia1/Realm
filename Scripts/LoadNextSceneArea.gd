extends Area2D

var nextID = 1

func _ready():
	connect("body_entered", get_parent().get_parent().get_parent(), "_on_LoadNextSceneArea_body_entered", [nextID])
