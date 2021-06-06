
extends Node

const LVL_PATH = "res://Scenes/Level%d.tscn"

export (float) var fade_time = 0.5

var lvl_num:int = 1
onready var Level = preload("res://Scenes/BaseLevel.gd")


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("game")
	call_deferred("init")
	pass # Replace with function body.

func init():
	load_level(lvl_num)
	
	
func load_level(num:int):
	
	var old_level = get_level_node()
	
	if old_level != null:
		self.remove_child(old_level)
		old_level.queue_free()
	var lvl_scn = load(LVL_PATH % num)
	if lvl_scn != null:
		var lvl = lvl_scn.instance()
		self.add_child(lvl)
		return true
	else:
		print("LVL DOES NOT EXIST")
		return false
	
	pass
	
func get_level_node():
	if self.has_node("Level"):
		return self.get_node("Level")
	return null

func on_next_level():
	lvl_num +=1
	load_level(lvl_num)
		
	pass
