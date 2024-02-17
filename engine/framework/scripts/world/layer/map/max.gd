#*****************************************************************************
# @file    show.gd
# @author  MakerYang
#*****************************************************************************
extends SubViewport

@onready var camera = $Camera

func _ready() -> void:
	await get_parent().ready
	# 动态加载地图
	var map_loader = load(Global.get_player_map_path()).instantiate()
	# 将地图添加到场景中
	map_loader.position = Vector2(-12024, -8016)
	add_child(map_loader)
	# 将地图设置为最底层
	move_child(map_loader, 0)
