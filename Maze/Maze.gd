extends Node3D

const N = 1 					 #binary 0001
const E = 2 					 #binary 0010
const S = 4 					 #binary 0100
const W = 8 					 #binary 1000

var cell_walls = {
	Vector2(0, -1): N, 			# cardinal directions for NESW
	Vector2(1, 0): E,
	Vector2(0, 1): S, 
	Vector2(-1, 0): W
}

var map = []

var tiles = [
	preload("res://Terrain/tile_0.tscn")
	,preload("res://Terrain/tile_1.tscn")
	,preload("res://Terrain/tile_2.tscn")
	,preload("res://Terrain/tile_3.tscn")
	,preload("res://Terrain/tile_4.tscn")
	,preload("res://Terrain/tile_5.tscn")
	,preload("res://Terrain/tile_6.tscn")
	,preload("res://Terrain/tile_7.tscn")
	,preload("res://Terrain/tile_8.tscn")
	,preload("res://Terrain/tile_9.tscn")
	,preload("res://Terrain/tile_10.tscn")
	,preload("res://Terrain/tile_11.tscn")
	,preload("res://Terrain/tile_12.tscn")
	,preload("res://Terrain/tile_13.tscn")
	,preload("res://Terrain/tile_14.tscn")
	,preload("res://Terrain/tile_15.tscn")
	
]

var tile_size = 4 						# 2-meter tiles
var width = 6  						# width of map (in tiles)
var height = 6  						# height of map (in tiles)

func _ready():
	randomize()
	make_maze()


func check_neighbors(cell, unvisited):
	#returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
	
func make_maze():
	var unvisited = []  # array of unvisited tiles
	var stack = []
	#fill the map with solid tiles
	for x in range(width):
		map.append([])
		map[x].resize(height)
		for y in range(height):
			unvisited.append(Vector2(x, y))
			map[x][y] = N|E|S|W 		# 15
	var current = Vector2(0, 0)
	unvisited.erase(current)
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			var dir = next - current
			var current_walls = map[current.x][current.y] - cell_walls[dir]
			var next_walls = map[next.x][next.y] - cell_walls[-dir]
			map[current.x][current.y] = current_walls
			map[next.x][next.y] = next_walls
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
	map[0][0] &= E|S|W
	for x in range(width):
		for z in range(height):
			var tile = tiles[map[x][z]].instantiate()
			tile.position = Vector3(x*tile_size,0,z*tile_size)
			tile.name = "Tile_" + str(x) + "_" + str(z)
			add_child(tile)
