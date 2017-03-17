extends Node

onready var owner = get_parent()

export(String,\
	 'heal_player', 'damage_nearest'\
	) var use_function = ''

export(int) var param1 = 0

export(bool) var stackable = false
export(bool) var indestructible = false

var inventory_slot

func use():
	if use_function.empty():
		RPG.broadcast("The " +owner.name+ " cannot be used", RPG.COLOR_DARK_GREY)
		return
	if has_method(use_function):
		var result = call(use_function)
		if result != "OK":
			RPG.broadcast(result,RPG.COLOR_DARK_GREY)
			return
		if not indestructible:
			owner.kill()

func pickup():
	RPG.inventory.add_to_inventory(owner)

func drop():
	assert inventory_slot != null
	RPG.inventory.remove_from_inventory(inventory_slot,owner)

func _ready():
	owner.item = self


# USE FUNCTIONS
func heal_player():
	var amount = self.param1
	if RPG.player.fighter.is_hp_full():
		return "You're already at full health"
	RPG.player.fighter.heal_damage(owner.name, amount)
	return "OK"

func damage_nearest():
	var amount = self.param1
	var target = RPG.map.get_nearest_visible_actor()
	if not target:
		return "No targets in sight"
	target.fighter.take_damage("Lightning Strike", amount)
	var fx_tex = preload('res://graphics/effects/bolt01.png')
	RPG.map.spawn_fx(fx_tex, target.get_map_pos())
	return "OK"

