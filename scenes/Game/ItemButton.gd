extends Button

var item = null setget _set_item



func _set_item(what):
	item = what
	set_text(item.name)
	set_button_icon(item.get_icon())
