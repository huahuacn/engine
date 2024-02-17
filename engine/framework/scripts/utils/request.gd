#*****************************************************************************
# @file    request.gd
# @author  MakerYang
#*****************************************************************************
extends Node

# 初始化自定义数据
var http_url:String = "https://game.geekros.com"
var http_token:String = "YqXLemvpOz85Jxy02QV7qAxJ31YZnNW6LBDoedKzKkXeJ8YvdEMwjVP941pQ7r3Pc2bLgBOa6ox3RqWN52DyZmnA04jpaRwXz598MP0gyEO2kvmoBZ79aKAQDn6d4W3P"
var http_request:HTTPRequest = HTTPRequest.new()
var http_callback = null
var http_headers = [
	"Content-Type: application/json",
	"Game-Token: ",
	"User-Token: ",
]

func on_service(path: String, method: int, data, callback) -> void:
	if !http_request.is_inside_tree():
		add_child(http_request)
	var json_data = JSON.stringify(data)
	http_headers[1] = "Game-Token: " + http_token
	http_headers[2] = "User-Token: " + Global.get_account_token()
	if http_callback and http_request.is_connected("request_completed", http_callback):
		http_request.request_completed.disconnect(http_callback)
	http_request.request_completed.connect(callback)
	http_callback = callback
	http_request.request(http_url + path, http_headers, method, json_data)
