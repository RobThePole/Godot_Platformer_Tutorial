extends Node

const WALL = 0
const COIN = 1
const PLAYER = 2
const PORTAL = 3
const ENEMY = 4
const DOOR = 5

export (PackedScene) var wall
export (PackedScene) var coin
export (PackedScene) var player
export (PackedScene) var portal
export (PackedScene) var enemy
export (PackedScene) var door



func _ready():
	call_deferred("setup_tiles")
	pass
	
func setup_tiles():
	var cells = $TileMap.get_used_cells()
	for cell in cells:
		var index = $TileMap.get_cell(cell.x,cell.y)
		match index:
			WALL:
				create_instance_from_tilemap(cell,wall,self,Vector2(8,8))
			COIN:
				create_instance_from_tilemap(cell,coin,self,Vector2(8,10))
			PLAYER:
				create_instance_from_tilemap(cell,player,self,Vector2(4,4))
			PORTAL:
				create_instance_from_tilemap(cell,portal,self,Vector2(8,8))
			ENEMY:
				create_instance_from_tilemap(cell,enemy,self,Vector2(6,10))
			DOOR:
				create_instance_from_tilemap(cell,door,self,Vector2(8,8))

func create_instance_from_tilemap(coord:Vector2, prefab:PackedScene,parent:Node,offset:Vector2 = Vector2.ZERO):
	$TileMap.set_cell(coord.x,coord.y,-1)
	var pf = prefab.instance()
	pf.position = $TileMap.map_to_world(coord) + offset
	parent.add_child(pf)
