extends PopupPanel

signal cancelled(cancel_string)
signal items_selected(items)

const MODE_EXAMINE = 0	# Show info when Object hovered, selection disabled
const MODE_DROP = 1		# Queue up item(s) to drop
const MODE_SELECT = 2	# Return the first Object clicked (choose an item to identify/enchant/etc)

onready var item_box = get_node('frame/Contents/Items')



var mode = MODE_DROP

func start(mode, header='', footer=''):
	# set mode
	self.mode = mode
	# set header/footer text
	get_node('frame/Header').set_text(header)
	get_node('frame/Footer').set_text(footer)
	# refresh contents
	clear_items()
	fill_from_inventory()
	# pause and show
	get_tree().set_pause(true)
	show()

func clear_items():
	for i in range(item_box.get_child_count()):
		item_box.get_child(0).queue_free()

func fill_from_inventory():
	var items = RPG.inventory.get_objects()
	
	for itm in items:
		var ob = preload('res://scenes/Game/ItemButton.tscn').instance()
		item_box.add_child(ob)
		ob.item = itm

func done():
		# unpause game and hide menu
		get_tree().set_pause(false)
		hide()

func _ready():
	set_process_input(true)

func _input(event):
	var CANCEL = event.is_action_pressed('act_CANCEL')
	var DROP = event.is_action_pressed('act_DROP')
	
	var CONFIRM = false
	if mode == MODE_DROP:	CONFIRM = DROP
	
	
	
	if CANCEL:
		done()
		# if needed for callback
		emit_signal('items_selected', []) # signal no items selected
		emit_signal('cancelled', "action cancelled")
	
	if CONFIRM:
		# process by mode
		if mode == MODE_DROP:
			var items = []
			for itm in item_box.get_children():
				if itm.is_pressed():
					items.append(itm.item)
			emit_signal('items_selected', items)
		done()