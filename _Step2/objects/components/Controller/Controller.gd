extends Node

onready var object = get_parent()

func _ready():
	RPG.player = object
	set_process_input(true)


func _input(event):
	if event.type == InputEvent.KEY and event.pressed:
		var UP = event.scancode == KEY_UP
		var DOWN = event.scancode == KEY_DOWN
		var LEFT = event.scancode == KEY_LEFT
		var RIGHT = event.scancode == KEY_RIGHT
		
		if UP:
			object.step(Vector2(0,-1))
		if DOWN:
			object.step(Vector2(0,1))
		if LEFT:
			object.step(Vector2(-1,0))
		if RIGHT:
			object.step(Vector2(1,0))
