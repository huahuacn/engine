#*****************************************************************************
# @file    roles.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 实例化节点树中的资源
@onready var sound:AudioStreamPlayer = $Sound
@onready var create:Control = $Create
@onready var create_career:AnimatedSprite2D = $Create/Career
@onready var create_describe:Control = $Create/Describe
@onready var create_switch:Control = $Create/Switch
@onready var create_nickname:LineEdit = $Create/Data/Nickname/Background/Input
@onready var create_men:TextureButton = $Create/Data/Men
@onready var create_women:TextureButton = $Create/Data/Women
@onready var create_submit_button:TextureButton = $Create/Data/SubmitButton
@onready var select:Control = $Select
@onready var select_career:AnimatedSprite2D = $Select/Career
@onready var select_switch:Control = $Select/Switch
@onready var select_level_label:Label = $Select/Data/Level
@onready var select_nickname_label:Label = $Select/Data/Nickname
@onready var select_career_label:Label = $Select/Data/Career
@onready var select_gender_label:Label = $Select/Data/Gender
@onready var start:Control = $Start
@onready var right_create_button:TextureButton = $Right/CreateButton

# 自定义信号
signal return_button_pressed
signal start_button_pressed

# 初始化节点数据
var node_type:String = ""
var node_role_index:int = 0
var node_career:int = 0
var node_gender:int = 0
var node_gender_array: Array = ["men", "women"]
var node_career_array: Array = [
	{"career": "warrior", "name": "战士", "offset": [Vector2(55, 39), Vector2(55, 57)]},
	{"career": "mage", "name": "法师", "offset": [Vector2(-27, 12), Vector2(15, 43)]},
	{"career": "taoist", "name": "道士", "offset": [Vector2(47, 0), Vector2(-46, 61)]}
]

func _ready() -> void:
	# 隐藏当前节点场景
	modulate.a = 0
	# 默认隐藏创建相关的控件
	create.visible = false
	start.visible = false
	select.visible = false
	# 默认隐藏角色动画
	create_career.animation = "default"

func _process(_delta) -> void:
	# 角色切换
	if node_type == "create":
		# 性别切换
		if node_gender == 0:
			create_men.button_pressed = true
			create_women.button_pressed = false
		else:
			create_women.button_pressed = true
			create_men.button_pressed = false
		# 职业描述切换
		for i in range(len(node_career_array)):
			if i == node_career:
				create_describe.get_child(i).visible = true
			else:
				create_describe.get_child(i).visible = false
		right_create_button.button_pressed = true
		create.visible = true
		select.visible = false
		start.visible = false
		create_career.animation = (node_career_array[node_career]["career"] + "_" + node_gender_array[node_gender])
		create_career.offset = node_career_array[node_career]["offset"][node_gender]
		create_career.play()
	else:
		# 开始游戏按钮显示状态
		if len(Global.get_account_area_role_list()) > 0:
			select.visible = true
			start.visible = true
			# 玩家角色管理
			var select_role = Global.get_account_area_role(node_role_index)
			for i in range(len(node_career_array)):
				if node_career_array[i]["career"] == select_role["role_career"]:
					var gender = 0
					var gender_string = ""
					if select_role["role_gender"] == "men":
						gender = 0
						gender_string = "男"
					if select_role["role_gender"] == "women":
						gender = 1
						gender_string = "女"
					select_level_label.text = "Level." + str(select_role["role_asset_level"])
					select_nickname_label.text = select_role["role_nickname"]
					select_career_label.text = node_career_array[i]["name"]
					select_gender_label.text = gender_string
					select_career.animation = (node_career_array[i]["career"] + "_" + node_gender_array[gender])
					select_career.offset = node_career_array[i]["offset"][gender]
					select_career.play()
		else:
			select.visible = false
			start.visible = false
		right_create_button.button_pressed = false
		create.visible = false
		create_career.animation = "default"
		create_career.offset = Vector2(0, 0)
		create_career.stop()

func _on_submit_button_pressed() -> void:
	if create_nickname.text != "":
		var submit_data = {
			"token": Global.get_account_area_token(),
			"nickname": create_nickname.text,
			"gender":  node_gender_array[node_gender],
			"career": node_career_array[node_career]["career"]
		}
		create_submit_button.disabled = true
		Request.on_service("/game/user/role/create", HTTPClient.METHOD_POST, submit_data, func (_result, code, _headers, body):
			if code == 200:
				var response = JSON.parse_string(body.get_string_from_utf8())
				if response["code"] == 0:
					get_parent().on_message("角色创建成功", 0)
					var current_role:Array = Global.get_account_area_role_list()
					current_role.push_front(response["data"]["role"])
					Global.set_account_area_role_list(current_role)
					node_role_index = 0;
					create_submit_button.disabled = false
					_on_cancel_button_pressed()
				else:
					create_submit_button.disabled = false
					get_parent().on_message(response["msg"], 0)
			else:
				create_submit_button.disabled = false
				get_parent().on_message("角色创建失败，请重新尝试", 0)
		)
	else:
		get_parent().on_message("角色信息不完整", 0)

func _on_return_button_pressed() -> void:
	# 返回登录界面
	return_button_pressed.emit()

func _on_start_button_pressed() -> void:
	# 开始游戏按钮
	var select_role = Global.get_account_area_role(node_role_index)
	# 更新玩家数据
	Global.update_player_data(select_role)
	# 发射信号
	start_button_pressed.emit()

func _on_create_switch_left_button_pressed() -> void:
	if node_career > 0:
		node_career -= 1;

func _on_create_switch_right_button_pressed() -> void:
	if node_career < 2:
		node_career += 1;

func _on_select_switch_left_button_pressed() -> void:
	if node_role_index > 0:
		node_role_index -= 1;

func _on_select_switch_right_button_pressed() -> void:
	if node_role_index < (len(Global.get_account_area_role_list()) - 1):
		node_role_index += 1;

func _on_men_pressed() -> void:
	node_gender = 0

func _on_women_pressed() -> void:
	node_gender = 1

func _on_create_button_pressed() -> void:
	node_type = "create"

func _on_cancel_button_pressed() -> void:
	node_type = ""
	create_nickname.text = ""
	node_career = 0
	node_gender = 0

func _on_sound_finished() -> void:
	# 确保背景音效循环播放
	sound.play()
