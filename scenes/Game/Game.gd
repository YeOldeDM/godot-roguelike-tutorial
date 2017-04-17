extends Container



signal map_clicked(cell)

onready var messagebox = get_node('frame/left/MessageBox')
onready var playerinfo = get_node('frame/right/PlayerInfo')
onready var viewport_panel = get_node('frame/left/map')

onready var inventory_menu = get_node('InventoryMenu')

var is_mouse_in_map = false setget _set_is_mouse_in_map
var mouse_cell = Vector2() setget _set_mouse_cell


func new_game():
	RPG.map.new_map()
	spawn_player(DungeonGen.start_pos)









# Save Game Mother Function
func save_game():
	
	# create a new file object to work with
	var file = File.new()
	var opened = file.open(RPG.SAVEGAME_PATH, File.WRITE)
	
	# Alert and return error if file can't be opened
	if not opened == OK:
		OS.alert("Unable to access file " + RPG.SAVEGAME_PATH)
		return opened

	# Gather data to save
	var data = {}
	
	# Map data: Datamap and Fogmap
	data.map = RPG.map.save()
	
	# Player object data
	data.player = RPG.player.save()
	
	# Global player data
	data.player_data = RPG.player_data
	var c = RPG.player_data.hair_color
	data.player_data.hair_color = {
		'r':c.r,
		'g':c.g,
		'b':c.b
		}
	
	# non-player Objects group
	data.objects = []
	data.inventory = []
	for node in get_tree().get_nodes_in_group('objects'):
		if node != RPG.player:
			if node.is_in_group('world'):
				data.objects.append(node.save())
			elif node.is_in_group('inventory'):
				data.inventory.append(node.save())
		
#	# Inventory group
#	data.inventory = []
#	for node in get_tree().get_nodes_in_group('inventory'):
#		data.inventory.append(node.save())
	
	# Store data and close file
	file.store_line(data.to_json())
	file.close()
	# Return OK if all goes well
	return opened








# Restore Game Mother Function
func restore_game():
	
	# create a new file object to work with
	var file = File.new()
	
	# return error if file not found
	if not file.file_exists(RPG.SAVEGAME_PATH):
		OS.alert("No file found at " + RPG.SAVEGAME_PATH)
		return ERR_FILE_NOT_FOUND

	var opened = file.open(RPG.SAVEGAME_PATH, File.READ)
	
	# Alert and return error if file can't be opened
	if not opened == OK:
		OS.alert("Unable to access file " + RPG.SAVEGAME_PATH)
		return opened

	# Dictionary to store file data
	var data = {}
	
	# Parse data from json file
	while not file.eof_reached():
		data.parse_json(file.get_line())
	
	################
	# Restore game from data
	################
	
	# Map Data
	if 'map' in data:
		RPG.map.restore(data.map)
	
	# Global Playerdata
	if 'player_data' in data:
		for key in data.player_data.keys():
			if key == 'hair_color':
				var c = data.player_data.hair_color
				RPG.player_data.hair_color = Color(c.r,c.g,c.b)
			else:
				RPG.player_data[key] = data.player_data[key]
	
	# Player data
	if 'player' in data:
		var start_pos = Vector2(data.player.x, data.player.y)
		spawn_player(start_pos)
		RPG.player.restore(data.player)
	
	# Object data
	if 'objects' in data:
		for entry in data.objects:
			var ob = restore_object(entry)
			var pos = Vector2(entry.x,entry.y)
			ob.spawn(RPG.map,pos)

	# Inventory data
	if 'inventory' in data:
		for entry in data.inventory:
			var ob = restore_object(entry)
			print(ob.item != null)
			ob.pickup()
	
	
	# close file and return status
	file.close()
	
	# build a Pathfinding map
	PathGen.build_map(RPG.MAP_SIZE,DungeonGen.get_floor_cells())
	
	return opened



func restore_object(data):
	var ob = load(data.filename).instance()
	ob = ob.restore(data)
	return ob





func spawn_player(cell):
	RPG.map.spawn_object('Player/Player',cell)
	var ob = RPG.player
	
	ob.connect("name_changed", RPG.game.playerinfo, "name_changed")
	ob.emit_signal("name_changed", ob.name)
	ob.fighter.connect("hp_changed", RPG.game.playerinfo, "hp_changed")
	ob.fighter.emit_signal("hp_changed",ob.fighter.hp, ob.fighter.max_hp)
	
	ob.name = RPG.player_data.name
	var race = RPG.player_data.race
	var gender = RPG.player_data.gender
	var base_tex = load('res://graphics/player/base/'+race+'_'+gender+'.png')
	var hair = RPG.player_data.hair
	var beard = RPG.player_data.beard
	if hair != null: hair = load(hair)
	if beard != null: beard = load(beard)
	
	ob.get_node('Sprite').set_texture(base_tex)
	ob.get_node('Paperdoll/Hair').set_texture(hair)
	ob.get_node('Paperdoll/Beard').set_texture(beard)
	ob.get_node('Paperdoll/Hair').set_modulate(RPG.player_data.hair_color)
	ob.get_node('Paperdoll/Beard').set_modulate(RPG.player_data.hair_color)



func pos_in_map(pos):
	var rect = Rect2(pos,Vector2(1,1))
	return viewport_panel.get_rect().intersects(rect)



func _ready():
	get_tree().set_auto_accept_quit(false)
	RPG.game = self
	messagebox.set_scroll_follow(true)
	set_process_input(true)
	if RPG.restore_game:
		restore_game()
	else:
		new_game()

	

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		var saved = save_game()
		if saved != OK:
			print('SAVE GAME RETURNED ERROR '+str(saved))
		get_tree().quit()

func _input( ev ):
	if ev.type == InputEvent.MOUSE_MOTION:
		self.is_mouse_in_map = pos_in_map(ev.pos)
		var new_mouse_cell = RPG.map.world_to_map(RPG.map.get_local_mouse_pos())
		if new_mouse_cell != mouse_cell:
			self.mouse_cell = new_mouse_cell
	if ev.type == InputEvent.MOUSE_BUTTON and ev.pressed:
		if self.is_mouse_in_map:
			if ev.button_index == BUTTON_LEFT:
				emit_signal('map_clicked', self.mouse_cell)
		if ev.button_index == BUTTON_RIGHT:
			emit_signal('map_clicked', null)

func _set_is_mouse_in_map(what):
	is_mouse_in_map = what
	RPG.map.set_cursor_hidden(!is_mouse_in_map)

func _set_mouse_cell(what):
	mouse_cell = what
	RPG.map.set_cursor()






