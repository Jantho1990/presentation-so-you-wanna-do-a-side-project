@tool
# Allows child control positions to be animated and modified while being children of a container.
# Only supports one child.
class_name AnimationWrapper
extends Control


var _childNode : Node


func _init() -> void:
  child_entered_tree.connect(_on_Child_entered_tree)
  child_exiting_tree.connect(_on_Child_exiting_tree)


func _on_Child_entered_tree(childNode: Node) -> void:
  if _childNode:
    _childNode.item_rect_changed.disconnect(_on_ChildNode_item_rect_changed)

  _childNode = childNode
  
  _childNode.item_rect_changed.connect(_on_ChildNode_item_rect_changed)


func _on_Child_exiting_tree(childNode: Node) -> void:
  childNode.item_rect_changed.disconnect(_on_ChildNode_item_rect_changed)
  _childNode = null
  
  
func _on_ChildNode_item_rect_changed() -> void:
  size = _childNode.size
  custom_minimum_size = _childNode.size
