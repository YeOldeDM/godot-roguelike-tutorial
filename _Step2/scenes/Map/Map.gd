extends TileMap

# Basic Map
# -1=nocell, 0=Wall, 1=Floor

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
	return get_cellv(cell)==1


func _ready():
	RPG.map = self
