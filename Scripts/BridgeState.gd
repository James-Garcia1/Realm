extends CollisionPolygon2D

func max_length():
	if Global.bridgeLength01 == Global.bridgeMaxLength01:
		return true
	return false
	
func set_collison_position():
	position.x = (Global.bridgeLength01 - 1) * 135
	position.y = (Global.bridgeLength01 - 1) * -50

func _ready():
	if (max_length()):
		disabled = true
	set_collison_position()

func _process(delta):
	if (max_length()):
		disabled = true
	else:
		set_collison_position()
