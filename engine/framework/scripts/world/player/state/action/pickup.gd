#*****************************************************************************
# @file    pickup.gd
# @author  MakerYang
#*****************************************************************************
extends StateBase

# 定义玩家节点
@export var player:Player

# 定义状态锁
var status_lock:bool

func _ready() -> void:
	player = get_parent().get_parent()

func enter() -> void:
	super.enter()
	player.player_action = "pickup"
	status_lock = true

func process_update(delta: float) -> void:
	super.process_update(delta)

func physics_process_update(delta: float) -> void:
	super.physics_process_update(delta)
	# 切换玩家状态
	player.on_switch_action_status()
	# 状态检测
	if Event.get_key() != "Ctrl":
		status_lock = false
	if !status_lock:
		state_machine.change_state("Stand")
