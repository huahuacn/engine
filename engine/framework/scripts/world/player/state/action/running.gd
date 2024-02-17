#*****************************************************************************
# @file    running.gd
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
	player.player_action = "running"

func process_update(delta: float) -> void:
	super.process_update(delta)

func physics_process_update(delta: float) -> void:
	super.physics_process_update(delta)
	# 切换玩家状态
	player.on_switch_action_status()
	# 位置检测
	if player.position != player.player_target_position and player.player_move_speed > 0:
		player.velocity = player.position.direction_to(player.player_target_position) * player.player_move_speed
		if player.position.distance_squared_to(player.player_target_position) > 5:
			player.move_and_slide()
		else:
			player.position = player.player_target_position
			state_machine.change_state("Stand")
