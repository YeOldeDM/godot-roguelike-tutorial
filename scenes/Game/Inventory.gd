extends GridContainer

onready var objects = get_node('../InventoryObjects')

func get_free_slot():
	for node in get_children():
		if node.contents.empty():
			return node

func get_matching_slot(item):
	for node in get_children():
		if node.contents[0].name == item.name:
			return node


func add_to_inventory(item):
	# find a matching slot
	var slot = get_matching_slot(item)
	# find free slot if no matches found
	if !slot: slot = get_free_slot()
	# break if no slots free
	if !slot: return
	
	# remove from world objects group
	if item.is_in_group('objects'):
		item.remove_from_group('objects')
	# add to inventory group
	if not item.is_in_group('inventory'):
		item.add_to_group('inventory')

func _ready():
	RPG.inventory = self





