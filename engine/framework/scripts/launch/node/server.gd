#*****************************************************************************
# @file    server.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 实例化节点树中的资源
@onready var server_list_box:VBoxContainer = $Main/ListBox/List

# 自定义信号
signal item_pressed(token: String)

# 初始化节点数据
var server_list: Array = []
var selected_token: String = ""

func _ready() -> void:
	# 设置节点默认数据
	selected_token = Global.get_account_area_token()
	server_list = Global.get_account_area_list()
	# 显示当前节点场景
	visible = true

func update_server() -> void:
	server_list = Global.get_account_area_list()
	# 清空服务器列表
	while server_list_box.get_child_count() > 0:
		var last_child = server_list_box.get_child(server_list_box.get_child_count() - 1)
		server_list_box.remove_child(last_child)
		last_child.queue_free()
	# 渲染服务器列表
	var font_path = load("res://framework/statics/fonts/msyh.ttc")
	var texture_normal = load("res://framework/statics/scenes/launch/node/server/server_button_0.png")
	var texture_pressed = load("res://framework/statics/scenes/launch/node/server/server_button_1.png")
	var texture_hover = load("res://framework/statics/scenes/launch/node/server/server_button_2.png")
	for i in range(len(server_list)):
		var item:TextureButton = TextureButton.new()
		var item_label:Label = Label.new()
		item.texture_normal = texture_normal
		item.texture_pressed = texture_pressed
		item.texture_hover = texture_hover
		item.texture_disabled = texture_normal
		item_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		item_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		item_label.text = server_list[i]["area_name"]
		item_label.size = Vector2(157, 24)
		item_label.position = Vector2(10, 11)
		item_label.add_theme_font_size_override("font_size", 12)
		item_label.add_theme_color_override("font_color", Color("#cba368"))
		item_label.add_theme_font_override("font", font_path)
		item.add_child(item_label)
		item.connect("pressed", _on_item_pressed.bind(server_list[i]["token"]))
		server_list_box.add_child(item)

func _on_item_pressed(token: String) -> void:
	for i in range(server_list_box.get_child_count()):
		# 禁用点击
		server_list_box.get_child(i).disabled = true
	item_pressed.emit(token)
