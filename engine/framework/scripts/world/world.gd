#*****************************************************************************
# @file    world.gd
# @author  MakerYang
#*****************************************************************************
extends Node2D

@export var player_node:Node2D

func _ready() -> void:
	# 加载玩家地图
	on_loader_map_node()
	# 加载用户界面
	on_loader_layer_node()
	# 连接服务器
	var error = Server.create_client()
	if error == OK:
		await multiplayer.multiplayer_peer.peer_connected
		# 将玩家数据发送给服务器
		var client_id:int = Global.get_player_client_id()
		var player_data:String = JSON.stringify(Global.get_player_data())
		Server.on_create_player.rpc(client_id, player_data)

func on_loader_map_node() -> void:
	var map_loader = load(Global.get_player_map_path()).instantiate()
	add_child(map_loader)

func on_loader_layer_node() -> void:
	var layer_loader = load("res://framework/scenes/world/layer/layer.tscn").instantiate()
	add_child(layer_loader)

func on_return_launch() -> void:
	var launch_path = "res://framework/scenes/launch/launch.tscn"
	Global.data["source"] = "world"
	get_tree().change_scene_to_file(launch_path)
