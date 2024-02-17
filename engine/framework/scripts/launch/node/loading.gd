#*****************************************************************************
# @file    loading.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 实例化节点树中的资源
@onready var progress:TextureProgressBar = $Progress/Texture

# 初始化节点数据
var world_scene_path = "res://framework/scenes/world/world.tscn"
var is_loader = false
var loader_progress = []

func _ready() -> void:
	# 初始化加载状态
	is_loader = false
	# 初始化进度条
	progress.value = 0

func _process(_delta) -> void:
	if is_loader:
		# 加载世界场景
		ResourceLoader.load_threaded_request(world_scene_path)
		var loader_status = ResourceLoader.load_threaded_get_status(world_scene_path, loader_progress)
		progress.value = (loader_progress[0] * 100)
		if loader_status == ResourceLoader.THREAD_LOAD_LOADED:
			set_process(false)
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file(world_scene_path)
			is_loader = false
			visible = false

func on_loader() -> void:
	if !is_loader:
		is_loader = true
