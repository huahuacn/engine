#*****************************************************************************
# @file    stand.gd
# @author  MakerYang
#*****************************************************************************
extends StateBase

# 定义玩家节点
@export var player:Player

func _ready() -> void:
	# 初始化玩家节点
	player = get_parent().get_parent()

func enter() -> void:
	super.enter()
	player.player_action = "stand"
	player.player_move_status = false

func process_update(delta: float) -> void:
	super.process_update(delta)

func physics_process_update(delta: float) -> void:
	super.physics_process_update(delta)
	# 切换玩家状态
	player.on_switch_action_status()
	# 状态检测
	if player.player_action == "walking" and !player.player_move_status and player.player_mouse_position.length() > 40:
		# 更新运动状态
		player.player_move_status = true
		# 更新目标位置
		player.update_target_position()
		# 切换状态
		state_machine.change_state("Walking")
	if player.player_action == "running" and !player.player_move_status and player.player_mouse_position.length() > 40:
		# 更新运动状态
		player.player_move_status = true
		# 更新目标位置
		player.update_target_position()
		# 切换状态
		state_machine.change_state("Running")
	if player.player_action == "attack" and !player.player_move_status:
		# 切换状态
		state_machine.change_state("Attack")
	if player.player_action == "pickup" and !player.player_move_status:
		# 切换状态
		state_machine.change_state("Pickup")
	if player.player_action == "launch" and !player.player_move_status:
		# 切换状态
		state_machine.change_state("Launch")
