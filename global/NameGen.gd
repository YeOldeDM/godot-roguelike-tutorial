extends Node

var N = "..baloratearnab.lemurevioxo.itwen.logetunuert.om"

func get_pair():
	var r = randi()%N.length()/2
	var pair = N[r]+N[r+1]
	return pair.replace('.','')

func get_name(pairs=4):
	var name = ''
	for i in range(pairs):
		name += get_pair()
	return name.capitalize()