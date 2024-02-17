#*****************************************************************************
# @file    player.gd
# @author  MakerYang
#*****************************************************************************
extends CharacterBody2D

## 玩家类
class_name Player

# 实例化控件
@onready var player_father:Control = $Father
@onready var player_body:Control = $Father/Body
@onready var player_body_weapon_index:Control = $Father/Body/WeaponIndex
@onready var player_body_wing_index:Control = $Father/Body/WingIndex
@onready var player_body_clothe_box:Control = $Father/Body/ClotheBox
@onready var player_body_weapon_box:Control = $Father/Body/WeaponBox
@onready var player_body_wing_box:Control = $Father/Body/WingBox
@onready var player_header:Control = $Father/Header
@onready var player_header_life_value:Label = $Father/Header/LifeValue
@onready var player_header_life:TextureProgressBar = $Father/Header/Life
@onready var player_header_magic:TextureProgressBar = $Father/Header/Magic
@onready var player_nickname:Label = $Father/NickName
@onready var player_camera:Camera2D = $Camera

# 初始化节点数据
@export var player_control_status:bool
@export var player_token:String
@export var player_data:Dictionary
@export var player_client_id:int
@export var player_angle:int
@export var player_clothe:AnimatedSprite2D
@export var player_weapon:AnimatedSprite2D
@export var player_wing:AnimatedSprite2D
@export var player_action:String
@export var player_move_status:bool
@export var player_move_speed:int
@export var player_move_step:int
@export var player_mouse_position:Vector2
@export var player_target_position:Vector2

# 如果鼠标事件未被其他场景、节点等资源消耗则触发该函数
func _unhandled_input(event) -> void:
	if event is InputEventMouseButton:
		if (event.button_index == 1 and event.pressed) or (event.button_index == 2 and event.pressed):
			player_control_status = true
		else:
			player_control_status = false

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	# 默认禁用控制
	player_control_status = false
	# 默认隐藏玩家主体
	player_father.visible = false
	# 相机权限
	player_camera.enabled = is_multiplayer_authority()

func _physics_process(_delta) -> void:
	if !Global.data["players"].has(name):
		return
	if player_token == "":
		# 初始化玩家数据
		init_player_data()
	if player_father.visible and is_multiplayer_authority():
		# 更新玩家数据
		update_player_data()
		# 获取窗口的边界
		var viewport_rect = get_viewport_rect()
		# 获取鼠标的位置
		var viewport_mouse_position = get_viewport().get_mouse_position()
		# 如果鼠标是否在窗口内且允许控制
		if viewport_rect.has_point(viewport_mouse_position) and !player_control_status:
			# 按键检测
			if player_action == "stand" and !player_move_status:
				# 获取鼠标位置
				player_mouse_position = get_local_mouse_position()
				if Event.is_skill():
					player_action = "launch"
			# 更新玩家方向
			on_switch_angle()
			# 切换玩家资源层级
			on_switch_weapon_index.rpc()
		if viewport_rect.has_point(viewport_mouse_position) and player_control_status:
			# 按键检测
			if player_action == "stand":
				if Event.get_button() == "left" and Event.get_key() == "" and !Event.is_skill():
					player_action = "walking"
				if Event.get_button() == "right" and Event.get_key() == "" and !Event.is_skill():
					player_action = "running"
				if Event.get_button() == "left" and Event.get_key() == "Shift" and !Event.is_skill():
					player_action = "attack"
				if Event.get_button() == "left" and Event.get_key() == "Ctrl"  and !Event.is_skill():
					player_action = "pickup"
			# 获取鼠标位置
			player_mouse_position = get_local_mouse_position()
			# 更新玩家方向
			on_switch_angle()
			# 切换玩家资源层级
			on_switch_weapon_index.rpc()
			# 更新速度与步距
			if player_mouse_position.length() > 40:
				if player_action == "walking":
					player_move_speed = 80
					player_move_step = 1
				if player_action == "running":
					player_move_speed = 160
					player_move_step = 2
			else:
				player_action = "stand"
				player_move_speed = 0
				player_move_step = 0

func init_player_data() -> void:
	# 更新玩家元数据
	player_data = Global.get_players_data(name)
	# 更新玩家客户端ID
	player_client_id = player_data["client_id"]
	# 更新玩家Token
	player_token = player_data["token"]
	# 初始化玩家方向
	player_angle = Global.get_player_angle(player_data)
	# 初始化玩家位置(地图坐标转世界坐标)
	position = Utils.convert_map_to_world(player_data["role_map"],Vector2(player_data["role_map_x"], player_data["role_map_y"]))
	# 初始化玩家动作
	player_action = "stand"
	player_target_position = position
	# 更新玩家数据
	update_player_data()
	# 加载玩家数据资源
	loader_player_resources()
	# 更新玩家资源层级
	on_switch_weapon_index.rpc()

func update_player_data() -> void:
	# 玩家昵称
	player_nickname.text = Global.get_player_nickname(player_data)
	# 玩家生命值、职业格式化数据
	player_header_life_value.text = Global.get_player_life_career_format(player_data)
	# 玩家生命值百分比
	player_header_life.value = Global.get_player_life_percentage(player_data)
	# 玩家魔法值百分比
	player_header_magic.value = Global.get_player_magic_percentage(player_data)
	# 更新玩家数据
	Global.update_player_data(player_data)

func loader_player_resources() -> void:
	# 加载玩家服饰
	player_clothe = Global.loader_player_clothe_resource(player_data)
	player_body_clothe_box.add_child(player_clothe)
	# 加载玩家武器
	player_weapon = Global.loader_player_weapon_resource(player_data)
	if player_weapon:
		player_body_weapon_box.add_child(player_weapon)
	# 加载玩家装饰
	player_wing = Global.loader_player_wing_resource(player_data)
	if player_wing:
		player_body_wing_box.add_child(player_wing)
	# 显示玩家主体
	player_father.visible = true

# 切换玩家方向
func on_switch_angle() -> void:
	if player_action in ["walking", "running", "attack", "pickup", "launch"] and !player_move_status:
		player_angle = Global.update_player_angle(player_data, wrapi(int(snapped(player_mouse_position.angle(), PI/4) / (PI/4)), 0, 8))

# 切换玩家动作状态
func on_switch_action_status() -> void:
	if player_clothe:
		player_clothe.animation = str(player_angle) + "_" + player_action
	if player_weapon:
		player_weapon.animation = str(player_angle) + "_" + player_action
	if player_wing:
		player_wing.animation = str(player_angle) + "_" + player_action

# 切换玩家资源层级
@rpc("any_peer", "call_local")
func on_switch_weapon_index() -> void:
	if player_weapon:
		if player_angle in [2, 3, 4, 5]:
			player_weapon.reparent(player_body_weapon_index)
		else:
			player_weapon.reparent(player_body_weapon_box)
	if player_wing:
		if player_angle in [1, 2, 3]:
			player_wing.reparent(player_body_wing_index)
		else:
			player_wing.reparent(player_body_wing_box)

# 更新目标位置
func update_target_position() -> void:
	var target_position = Vector2.ZERO
	var step = player_move_step
	var size = Global.get_map_grid_size()
	if player_angle == 0:
		target_position = Vector2(position.x + (step * size.x), position.y)
	if player_angle == 1:
		target_position = Vector2(position.x + (step * size.x), position.y + (step * size.y))
	if player_angle == 2:
		target_position = Vector2(position.x, position.y + (step * size.y))
	if player_angle == 3:
		target_position = Vector2(position.x - (step * size.x), position.y + (step * size.y))
	if player_angle == 4:
		target_position = Vector2(position.x - (step * size.x), position.y)
	if player_angle == 5:
		target_position = Vector2(position.x - (step * size.x), position.y - (step * size.y))
	if player_angle == 6:
		target_position = Vector2(position.x, position.y - (step * size.y))
	if player_angle == 7:
		target_position = Vector2(position.x + (step * size.x), position.y - (step * size.y))
	player_target_position = target_position
