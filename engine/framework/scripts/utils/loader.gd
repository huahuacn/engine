#*****************************************************************************
# @file    loader.gd
# @author  MakerYang
#*****************************************************************************
extends Node

# 初始化数据结构
var data = {
	"default_path": [
		"res://framework/scenes/world/world.tscn",
		"",
		"res://framework/scenes/world/player/player.tscn"
	],
	"loader_progress": {}
}

# 获取默认场景路径列表
func get_default_path_list() -> Array:
	return data["default_path"]

# 获取默认场景路径
func get_default_path(i: int) -> String:
	return data["default_path"][i]

# 获取世界场景路径
func get_world_scene_path() -> String:
	return data["default_path"][0]

# 获取玩家场景路径
func get_player_scene_path() -> String:
	return data["default_path"][2]

# 获取地图场景路径
func get_map_scene_path() -> String:
	return data["default_path"][1]

# 更新地图场景路径
func update_map_scene_path(path: String):
	data["default_path"][1] = path

# 请求加载资源
func load_resource(path: String) -> void:
	if not ResourceLoader.has_cached(path):
		ResourceLoader.load_threaded_request(path)
	if path not in data["loader_progress"]:
		data["loader_progress"][path] = []

# 获取资源加载进度
func get_resource_progress(path: String) -> float:
	return data["loader_progress"][path]

# 检查资源加载状态
func get_resource_status(path: String) -> Dictionary:
	var result = {
		"status": false,
		"progress": 0.0
	}
	if path in data["loader_progress"]:
		var status = ResourceLoader.load_threaded_get_status(path, data["loader_progress"][path])
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			result.status = true
		result.progress = data["loader_progress"][path]
	return result

# 获取已加载的资源
func get_resource_loaded(path: String) -> PackedScene:
	if ResourceLoader.load_threaded_get_status(path, data["loader_progress"][path]) == ResourceLoader.THREAD_LOAD_LOADED:
		return ResourceLoader.load_threaded_get(path)
	return null
