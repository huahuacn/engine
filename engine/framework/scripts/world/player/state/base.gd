#*****************************************************************************
# @file    base.gd
# @author  MakerYang
#*****************************************************************************
extends Node2D

## 基础状态
class_name StateBase

## 实例化状态机
var state_machine:StateMachine

## 进入状态
func enter() -> void:
	pass

## 退出状态
func exit() -> void:
	pass

## 渲染帧更新
func process_update(_delta: float) -> void:
	pass

## 渲染帧更新
func physics_process_update(_delta: float) -> void:
	pass
