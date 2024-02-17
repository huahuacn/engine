#*****************************************************************************
# @file    attack_stand.gd
# @author  MakerYang
#*****************************************************************************
extends StateBase

# 定义玩家节点
@export var player:Player

func _ready() -> void:
	player = get_parent().get_parent()

func enter() -> void:
	super.enter()
	player.player_action = "attack_stand"

func process_update(delta: float) -> void:
	super.process_update(delta)

func physics_process_update(delta: float) -> void:
	super.physics_process_update(delta)
	# 切换玩家状态
	player.on_switch_action_status()
	# 延迟切换状态
	state_machine.change_state("Stand")
