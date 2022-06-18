extends Node2D

export var size_x = 5
export var size_y = 5
export var tile_size = 64
export var tile_ids = ["Grass","SmallTree", "BigTree", "Sand", "Water"]

var empty = preload("res://objects/Empty.tscn")

class WFC:
	var possible_tiles = []
	var position = Vector2.ZERO	

var tiles = []
var wfcs = []

func _ready():
	for y in range(0, size_x):
		for x in range(0, size_y):
			var new_wfc = WFC.new()
			new_wfc.position.x = x * tile_size
			new_wfc.position.y = y * tile_size
			new_wfc.possible_tiles = tile_ids
			wfcs.append(new_wfc)
			
			var tile = empty.instance()
			tile.position.x = x * tile_size
			tile.position.y = y * tile_size
			tile.set_possible_tiles(tile_ids)
			tiles.append(tile)
			add_child(tile)

func _process(delta):
	
	pass

func collapse(mtile, tile_id):
	mtile.collapse(tile_id)

func _unhandled_input(event):
	if Input.is_action_just_released("left_click"):
		get_tree().set_input_as_handled() 
		var pos = get_global_mouse_position()
		for mtile in tiles:
			if not "spacing" in mtile:
				continue
			for tile in mtile.get_tiles():
				var sprite = tile.get_child(0)
				if sprite.get_rect().has_point(sprite.to_local(pos)):
					collapse(mtile, tile.get_name())
					#collapse(mtile, tile.get_name())
					
