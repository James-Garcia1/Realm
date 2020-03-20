extends Node2D

signal interact

func _ready():
	connect("interact",  , "_start")
