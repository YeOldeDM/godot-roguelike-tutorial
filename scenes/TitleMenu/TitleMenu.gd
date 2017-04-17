extends Control

func _ready():
	# check for save file
	var file = File.new()
	var save_exists = file.file_exists(RPG.SAVEGAME_PATH)
	var button = get_node('Main/box/options/Continue')
	button.set_disabled(!save_exists)

func _on_Continue_pressed():
	RPG.restore_game = true
	get_tree().change_scene('res://scenes/Game/Game.tscn')


func _on_New_pressed():
	get_node('CharGen').show()
	get_node('Main').hide()
	

func _on_Back_pressed():
	get_node('Main').show()
	get_node('CharGen').hide()

func _on_Quit_pressed():
	get_tree().quit()

