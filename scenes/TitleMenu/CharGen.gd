extends PanelContainer

onready var hair_color_picker = get_node('box/1/HairColor/Picker')
onready var name_picker = get_node('box/1/Name/NameEdit')

onready var doll_base = get_node('box/2/doll/Base')
onready var doll_beard = doll_base.get_node('Beard')
onready var doll_hair = doll_base.get_node('Hair')


var race = 'human' setget _set_race
var gender = 'm' setget _set_gender
var hair = null setget _set_hair
var beard = null setget _set_beard
var hair_color = Color(1,1,1) setget _set_hair_color


func start():
	var hair = doll_hair.get_texture()
	if hair != null: hair = hair.get_path()
	var beard = doll_beard.get_texture()
	if beard != null: beard = beard.get_path()
	
	RPG.player_data = {
		'name':		name_picker.get_text(),
		'race':		self.race,
		'gender':	self.gender,
		'hair':		hair,
		'beard':	beard,
		'hair_color':	self.hair_color
		}
	RPG.restore_game = false
	get_tree().change_scene('res://scenes/Game/Game.tscn')


func _set_base():
	var name = race + '_' + gender
	var tex = load('res://graphics/player/base/'+name+'.png')
	doll_base.set_texture(tex)


func _set_hair_color(what):
	hair_color = what
	doll_hair.set_modulate(hair_color)
	doll_beard.set_modulate(hair_color)


func _set_race(what):
	race = what
	_set_base()


func _set_gender(what):
	gender = what
	_set_base()


func _set_hair(what):
	hair = what
	if hair == null: 
		doll_hair.set_texture(null)
		return
	else:
		var tex = load('res://graphics/player/hair/'+hair+'.png')
		doll_hair.set_texture(tex)


func _set_beard(what):
	beard = what
	if beard == null:
		doll_beard.set_texture(null)
		return
	else:
		var tex = load('res://graphics/player/beard/'+beard+'.png')
		doll_beard.set_texture(tex)


func _on_Race_button_selected( button_idx ):
	self.race = ['human', 'elf', 'dwarf', 'halfling', 'gnome'][button_idx]


func _on_Gender_button_selected( button_idx ):
	self.gender = ['m', 'f'][button_idx]


func _on_Beard_button_selected( button_idx ):
	self.beard = [null, 'short', 'long'][button_idx]


func _on_Hair_button_selected( button_idx ):
	self.hair = [null, 'short', 'long', 'elf', 'fem'][button_idx]


func _on_Picker_color_changed( color ):
	self.hair_color = color


func _on_NameEdit_text_changed( text ):
	# Disable Start button if name is empty
	get_node('box/3/Start').set_disabled(text.empty())


func _on_RandName_pressed():
	var rname = NameGen.get_name(RPG.roll(3,5))
	name_picker.set_text(rname)
	_on_NameEdit_text_changed( rname )


func _on_Start_pressed():
	start()
