#*****************************************************************************
# @file    utils.gd
# @author  MakerYang
#*****************************************************************************
extends Node

# 验证邮箱格式
func check_mail_format(mail:String) -> bool:
	var check:bool = true
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$")
	if !regex.search(mail):
		check = false
	return check

# 获取当前时间
func get_current_time() -> String:
	var current_time = Time.get_time_dict_from_system()
	var hour = current_time.hour
	var minute = current_time.minute
	var second = current_time.second
	if hour < 10:
		hour = "0" + str(hour)
	if minute < 10:
		minute = "0" + str(minute)
	if second < 10:
		second = "0" + str(second)
	return str(hour) + ":" + str(minute) + ":" + str(second)

# TileMap坐标转换为World坐标
func convert_map_to_world(map_id: String, position_data: Vector2) -> Vector2:
	return get_parent().get_node("World").get_node(map_id).get_node("Map").map_to_local(position_data)

# World坐标转换为TileMap坐标
func convert_world_to_map(map_id: String, position_data: Vector2) -> Vector2:
	return get_parent().get_node("World").get_node(map_id).get_node("Map").local_to_map(position_data)
