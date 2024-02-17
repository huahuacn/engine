#*****************************************************************************
# @file    global.gd
# @author  MakerYang
#*****************************************************************************
extends Node

# 初始化数据结构
var data = {
	"varsion": "1.0.0",
	"source": "",
	"config": {
		"map_root_path": "res://framework/scenes/world/map/",
		"clothe_root_path": "res://framework/scenes/world/player/clothe/",
		"weapon_root_path": "res://framework/scenes/world/player/weapon/",
		"wing_root_path": "res://framework/scenes/world/player/wing/",
		"resource": {
			"speed_scale": 8,
		},
		"tilemap":{
			"grid_size": Vector2(48, 32)
		}
	},
	"account": {
		"token": "",
		"area": {
			"token": "",
			"list": []
		},
		"role": [],
		"player": {}
	},
	"players": {}
}

func _ready() -> void:
	# 限制窗口最小尺寸
	DisplayServer.window_set_min_size(Vector2(1280, 720))
	# 服务器模式检测
	if OS.has_feature("dedicated_server"):
		# 标记为服务器模式
		data["config"]["is_server"] = true
		# 创建服务器
		var error = Server.create_server()
		if error != OK:
			printerr("[服务器创建失败]")
		return

# 是否为服务器模式
func is_server() -> bool:
	return data["config"]["is_server"]

# 地图根路径
func get_map_root_path() -> String:
	return data["config"]["map_root_path"]

# 服饰根路径
func get_clothe_root_path() -> String:
	return data["config"]["clothe_root_path"]

# 武器根路径
func get_weapon_root_path() -> String:
	return data["config"]["weapon_root_path"]

# 翅膀根路径
func get_wing_root_path() -> String:
	return data["config"]["wing_root_path"]

# 更新TileMap网格尺寸
func get_map_grid_size() -> Vector2:
	return data["config"]["tilemap"]["grid_size"]

# 获取账号Token
func get_account_token() -> String:
	return data["account"]["token"]

# 设置账号Token
func set_account_token(token: String):
	data["account"]["token"] = token

# 获取账号服务区Token
func get_account_area_token() -> String:
	return data["account"]["area"]["token"]

# 设置账号服务区Token
func set_account_area_token(token: String):
	data["account"]["area"]["token"] = token

# 获取账号服务区列表
func get_account_area_list() -> Array:
	return data["account"]["area"]["list"]

# 设置账号服务区列表
func set_account_area_list(list: Array):
	data["account"]["area"]["list"] = list

# 获取账号服务区角色信息
func get_account_area_role(index: int):
	return data["account"]["role"][index]
	
# 获取账号服务区角色列表
func get_account_area_role_list() -> Array:
	return data["account"]["role"]

# 设置账号服务区角色列表
func set_account_area_role_list(list: Array):
	data["account"]["role"] = list

# 获取账号的玩家Token
func get_account_player_token() -> String:
	return data["account"]["player"]["token"]

# 更新并返回账号的玩家Token
func update_account_player_token(token: String) -> String:
	data["account"]["player"]["token"] = token
	return data["account"]["player"]["token"]

# 获取账号的玩家客户端ID
func get_player_client_id() -> int:
	return data["account"]["player"]["client_id"]

# 更新并返回玩家客户端ID
func update_player_client_id(client_id: int) -> int:
	data["account"]["player"]["client_id"] = client_id
	return data["account"]["player"]["client_id"]

# 获取玩家组中玩家数据
func get_players_data(client_id: String) -> Dictionary:
	return data["players"][client_id]

# 更新并返回玩家组中玩家数据
func update_players_data(client_id: String, player_data: Dictionary) -> Dictionary:
	data["players"][client_id] = player_data
	return data["players"][client_id]
	
# 删除玩家组中玩家数据
func delete_players_data(client_id: String) -> bool:
	return data["players"].erase(client_id)

# 获取玩家数据
func get_player_data() -> Dictionary:
	return data["account"]["player"]

# 更新玩家数据
func update_player_data(player_data: Dictionary) -> Dictionary:
	data["account"]["player"] = player_data
	return data["account"]["player"]

# 获取玩家昵称
func get_player_nickname(player_data: Dictionary) -> String:
	return player_data["role_nickname"]

# 获取玩家职业
func get_player_career(player_data: Dictionary) -> String:
	return player_data["role_career"]

# 获取玩家性别
func get_player_gender(player_data: Dictionary) -> String:
	return player_data["role_gender"]

# 获取玩家角度
func get_player_angle(player_data: Dictionary) -> int:
	return player_data["role_angle"]

# 更新并返回玩家角度
func update_player_angle(player_data: Dictionary, angle: int) -> int:
	player_data["role_angle"] = angle
	return player_data["role_angle"]

# 获取玩家等级
func get_player_level(player_data: Dictionary) -> int:
	return player_data["role_asset_level"]

# 获取玩家生命值
func get_player_life(player_data: Dictionary) -> int:
	return player_data["role_asset_life"]

# 获取玩家生命值百分比
func get_player_life_percentage(player_data: Dictionary) -> float:
	return (float(player_data["role_asset_life"]) / float(player_data["role_asset_life_max"])) * 100

# 获取玩家生命值格式化数据
func get_player_life_format(player_data: Dictionary) -> String:
	return str(player_data["role_asset_life"]) + "/" + str(player_data["role_asset_life_max"])

# 获取玩家生命值与职业格式化数据
func get_player_life_career_format(player_data: Dictionary) -> String:
	var career_level = ""
	if player_data["role_career"] == "warrior":
		career_level = "/Z" + str(player_data["role_asset_level"])
	if player_data["role_career"] == "mage":
		career_level = "/M" + str(player_data["role_asset_level"])
	if player_data["role_career"] == "taoist":
		career_level = "/T" + str(player_data["role_asset_level"])
	return str(player_data["role_asset_life"]) + "/" + str(player_data["role_asset_life_max"]) + career_level

# 获取玩家魔法值
func get_player_magic(player_data: Dictionary) -> int:
	return player_data["role_asset_magic"]

# 获取玩家魔法值百分比
func get_player_magic_percentage(player_data: Dictionary) -> float:
	return (float(player_data["role_asset_magic"]) / float(player_data["role_asset_magic_max"])) * 100

# 获取玩家魔法值格式化数据
func get_player_magic_format(player_data: Dictionary) -> String:
	return str(player_data["role_asset_magic"]) + "/" + str(player_data["role_asset_magic_max"])

# 获取玩家经验值
func get_player_experience(player_data: Dictionary) -> int:
	return player_data["role_asset_experience"]

# 获取玩家经验值百分比
func get_player_experience_percentage(player_data: Dictionary) -> float:
	return (float(player_data["role_asset_experience"]) / float(player_data["role_asset_experience_max"])) * 100

# 获取玩家地图编号
func get_player_map_id() -> String:
	return data["account"]["player"]["role_map"]

# 获取玩家地图名称
func get_player_map_name() -> String:
	return data["account"]["player"]["role_map_name"]

# 获取玩家地图资源路径
func get_player_map_path() -> String:
	return get_map_root_path() + data["account"]["player"]["role_map"] + ".tscn"

# 获取玩家服饰
func get_player_clothe_id(player_data: Dictionary) -> String:
	return player_data["role_body_clothe"]

# 获取玩家服饰资源路径
func get_player_clothe_path(player_data: Dictionary) -> String:
	return get_clothe_root_path() + player_data["role_body_clothe"] + "/" + player_data["role_gender"] + ".tscn"

# 获取玩家服饰资源
func loader_player_clothe_resource(player_data: Dictionary) -> AnimatedSprite2D:
	var clothe_path = get_player_clothe_path(player_data)
	var clothe_loader = load(clothe_path).instantiate()
	clothe_loader.name = "Clothe"
	clothe_loader.speed_scale = data["config"]["resource"]["speed_scale"]
	return clothe_loader

# 获取玩家武器编号
func get_player_weapon_id(player_data: Dictionary) -> String:
	return player_data["role_body_weapon"]

# 获取玩家武器资源路径
func get_player_weapon_path(player_data: Dictionary) -> String:
	return get_weapon_root_path() + player_data["role_body_weapon"] + "/" + player_data["role_gender"] + ".tscn"

# 获取玩家武器资源
func loader_player_weapon_resource(player_data: Dictionary) -> AnimatedSprite2D:
	if get_player_weapon_id(player_data) == "000":
		return null
	var weapon_path = get_player_weapon_path(player_data)
	var weapon_loader = load(weapon_path).instantiate()
	weapon_loader.name = "Weapon"
	weapon_loader.speed_scale = data["config"]["resource"]["speed_scale"]
	return weapon_loader

# 获取玩家翅膀编号
func get_player_wing_id(player_data: Dictionary) -> String:
	return player_data["role_body_wing"]

# 获取玩家翅膀资源路径
func get_player_wing_path(player_data: Dictionary) -> String:
	return get_wing_root_path() + player_data["role_body_wing"] + "/" + player_data["role_gender"] + ".tscn"

# 加载玩家翅膀装饰资源
func loader_player_wing_resource(player_data: Dictionary) -> AnimatedSprite2D:
	if get_player_wing_id(player_data) == "000":
		return null
	var wing_path = get_player_wing_path(player_data)
	var wing_loader = load(wing_path).instantiate()
	wing_loader.name = "Wing"
	wing_loader.speed_scale = data["config"]["resource"]["speed_scale"]
	return wing_loader

# 获取玩家当前坐标
func get_player_coordinate() -> Vector2:
	return data["account"]["player"]["coordinate"]

# 更新并返回玩家当前坐标
func update_player_coordinate(coordinate: Vector2) -> Vector2:
	data["account"]["player"]["coordinate"] = coordinate
	return data["account"]["player"]["coordinate"]
