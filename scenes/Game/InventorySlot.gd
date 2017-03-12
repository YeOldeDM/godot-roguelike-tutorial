extends Button

var contents = [] setget _set_contents



func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass





func _set_contents(what):
	contents = what
	if not contents.empty():
		get_node('Icon').set_texture(contents[0].get_node('Icon').get_texture())
		set_disabled(false)
	else:
		get_node('Icon').set_texture(null)
		set_disabled(true)

	var count = contents.size()
	var txt = str(count) if count > 1 else ''
	get_node('Count').set_text(txt)



