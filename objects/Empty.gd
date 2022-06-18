extends Node2D

var possible_tiles = []
var spacing = round(64/3)
var collapsed = false

func set_possible_tiles(possible_tiles):
	self.possible_tiles = possible_tiles 
	if self.collapsed:
		return
	update_display()

func get_tiles():
	var tiles = []
	for child in self.get_children():
		if "texture" in child:
			continue
		tiles.append(child)
	return tiles

func update_display():
	for child in self.get_children():
		if "texture" in child:
			continue
		remove_child(child)
	
	var i = 0
	for y in range(-1, 2):
		for x in range(-1, 2):
			if(i > self.possible_tiles.size()-1):
				return
			var tile = load("res://objects/tiles/%s.tscn" % (self.possible_tiles[i])).instance()
			tile.scale.x = .2
			tile.scale.y = .2
			tile.position.x = spacing * x
			tile.position.y = spacing * y
			add_child(tile)
			i = i+1

func collapse(tile_id):
	self.collapsed = true

	for child in self.get_children():
		remove_child(child)
	var tile = load("res://objects/tiles/%s.tscn" % tile_id).instance()
	self.set_possible_tiles(tile.pn)
	add_child(tile)

	for n in get_neigbours():
		n.iterate()
	
func get_neigbours():
	var neigbours = []
	
	for child in get_parent().get_children():
		if "zoom" in child:
			continue
		if child.position == Vector2(self.position.x + 64, self.position.y):
			neigbours.append(child)
		if child.position == Vector2(self.position.x - 64, self.position.y):
			neigbours.append(child)
		if child.position == Vector2(self.position.x, self.position.y + 64):
			neigbours.append(child)
		if child.position == Vector2(self.position.x, self.position.y - 64):
			neigbours.append(child)
	return neigbours
	
func iterate():
	if self.collapsed:
		return

	var to_be_iterated = []
	var neigbours = get_neigbours()
	var defining_tile = get_neigbour_with_lowest_entropy()
	var possible_neigbours = get_posibilities_from_tiles(defining_tile)
	
	for n in neigbours:
		possible_neigbours = constrain(possible_neigbours, get_posibilities_from_tiles(n))

	if self.possible_tiles != possible_neigbours:
		self.set_possible_tiles(possible_neigbours)
		for n in neigbours:
			n.iterate()

func get_neigbour_with_lowest_entropy():
	var tTile
	for tile in get_neigbours():
		if tTile == null:
			tTile = tile
			continue
		if get_entropy(tile) < get_entropy(tTile):
			tTile = tile
	return tTile

func get_entropy(mTile):
	return get_posibilities_from_tiles(mTile).size()

func get_posibilities_from_tiles(mTile):
	var posibilities = []
	for tile in mTile.get_tiles():
		for pn in tile.pn:
			if posibilities.find(pn) == -1:
				posibilities.append(pn)
	return posibilities

func constrain(array1, array2):
	var tempArray = []
	for i in array1:
		if array2.find(i) != -1 and tempArray.find(i) == -1:
			tempArray.append(i)
	for i in array2:
		if array1.find(i) != -1 and tempArray.find(i) == -1:
			tempArray.append(i)
	return tempArray
