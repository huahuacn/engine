extends Node

# 初始化自定义数据
var server_peer:ENetMultiplayerPeer
var client_peer:ENetMultiplayerPeer
var world_node:Node2D

var player_scene:PackedScene = preload("res://framework/scenes/world/player/player.tscn")

# 创建服务器并返回服务器状态
func create_server() -> int:
	print("[创建服务器...]")
	server_peer = ENetMultiplayerPeer.new()
	var error = server_peer.create_server(20090)
	if error == OK:
		multiplayer.multiplayer_peer = server_peer
		multiplayer.peer_connected.connect(_on_peer_connected)
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)
		# TODO 请求云服务获取当前游戏资源
		var game_maps: Array[String] = ["001"]
		on_init_node(game_maps)
		print("[服务器创建成功]")
	return error

# 初始化世界场景
func on_init_node(game_maps: Array) -> void:
	world_node = Node2D.new()
	world_node.name = "World"
	get_parent().call_deferred("add_child", world_node)
	for map in game_maps:
		var map_scene:Node2D = load(Global.get_map_root_path() + map + ".tscn").instantiate()
		world_node.add_child(map_scene)
		print("[初始化地图 %s]" % map)

# 客户端连接时回调函数
func _on_peer_connected(id: int) -> void:
	print("[新的客户端连接 " + str(id) + "]")
	rpc_id(id, "notice_players_data", JSON.stringify(Global.data["players"]))

func _on_peer_disconnected(id: int) -> void:
	print("[玩家离开 " + str(id) + "]")
	var player_data = Global.get_players_data(str(id))
	var players_node = get_parent().get_node("World").get_node(player_data["role_map"]).get_node("Players")
	if players_node.has_node(str(id)):
		players_node.get_node(str(id)).queue_free()
	Global.delete_players_data(str(id))

# 接收客户端消息
@rpc("any_peer", "call_remote")
func on_create_player(id: int, data: String) -> void:
	var player_data = JSON.parse_string(data)
	print("[玩家加入 " + str(id) + " " + Global.get_player_nickname(player_data) + "]")
	Global.update_players_data(str(id), player_data)
	rpc("notice_create_player", id, data)
	var players_node = get_parent().get_node("World").get_node(player_data["role_map"]).get_node("Players")
	var player_loader:Node2D = player_scene.instantiate()
	player_loader.name = str(id)
	player_loader.z_index = players_node.get_child_count() + 1
	players_node.add_child(player_loader)

@rpc("any_peer", "call_local")
func notice_create_player(id: int, data: String) -> void:
	var player_data = JSON.parse_string(data)
	print("[记录玩家数据 " + str(id) + " " + Global.get_player_nickname(player_data) + "]")
	Global.update_players_data(str(id), player_data)

@rpc("any_peer", "call_local")
func notice_players_data(data: String) -> void:
	var players_data = JSON.parse_string(data)
	print("[同步玩家数据]")
	print(players_data)
	Global.data["players"] = players_data

# 创建客户端并返回客户端状态
func create_client() -> int:
	client_peer = ENetMultiplayerPeer.new()
	var error = client_peer.create_client("43.130.40.138", 20090)
	if error == OK:
		multiplayer.multiplayer_peer = client_peer
		# 更新客户端ID
		Global.update_player_client_id(multiplayer.get_unique_id())
	return error
