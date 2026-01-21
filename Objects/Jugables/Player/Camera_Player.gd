extends Camera2D

@export var dead_zone_top := 80
@export var dead_zone_bottom := 80

@onready var player := get_parent()

func _process(_delta):
	var cam_y = global_position.y
	var player_y = player.global_position.y

	global_position = Vector2(player.global_position.x, -8)
