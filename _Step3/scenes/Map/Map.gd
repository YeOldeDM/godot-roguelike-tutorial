extends TileMap

# Basic Map
# -1=nocell, 0=Wall, 1=Floor


func spawn_object(partial_path,cell):
	var path = 'res://objects/' +partial_path+ '.tscn'
	var file = File.new()
	var exists = file.file_exists(path)
	if not exists: 
		OS.alert("no such object: "+path)
		return
	var ob = load(path).instance()
	ob.spawn(self,cell)

func draw_map():
	var family = TileFamily.FAMILY_STONE_GREY
	var datamap = DungeonGen.datamap
	for y in range(datamap.size()-1):
		for x in range(datamap[y].size()-1):
			var tile = datamap[y][x]
			var idx = -1
			if tile == 0: # Floor
				idx = RPG.roll(family[0][0],family[0][1])
			elif tile == 1:
				idx = RPG.roll(family[1][0],family[1][1])
			set_cell(x,y,idx)

func is_cell_blocked(cell):
	var blocks = is_wall(cell)
	var objects = get_objects_in_cell(cell)
	for obj in objects:
		if obj.blocks_movement:
			blocks = true
	return blocks

func get_objects_in_cell(cell):
	var list = []
	for obj in get_tree().get_nodes_in_group('objects'):
		if obj.get_map_pos() == cell:
			list.append(obj)
	return list

func is_wall(cell):
	return DungeonGen.datamap[cell.y][cell.x]==1


func _ready():
	RPG.map = self
	DungeonGen.generate()
	DungeonGen.map_to_text()
	draw_map()
	spawn_object('Player/Player',DungeonGen.start_pos)
