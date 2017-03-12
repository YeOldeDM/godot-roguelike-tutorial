extends Node2D

export(String, MULTILINE) var name = "OBJECT"
export(bool) var blocks_movement = false

# Step 1 tile in a direction
func step(dir):
	dir.x = clamp(dir.x, -1, 1)
	dir.y = clamp(dir.y, -1, 1)
	var new_cell = get_map_pos() + dir
	if not RPG.map.is_cell_blocked(new_cell):
		set_map_pos(new_cell)



# Set our position in map cell coordinates
func set_map_pos(cell):
	set_pos(RPG.map.map_to_world(cell))

# Get our position in map cell coordinates
func get_map_pos():
	return RPG.map.world_to_map(get_pos())




func _ready():
	add_to_group('objects')
		
		
		
