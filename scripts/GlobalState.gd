extends Node


### Basic global variables ###
# Game vars
var day: int = 1

# Player vars
var mental_health: int = 100
var money: int = 20
var karma: int = 0

# Flags
var flags: Dictionary
var inventory: Dictionary

# Test Flags
var hasEgg: bool = false
var hasShovel: bool = true



### Scenes ###
# Load the first scene, updated based on day
var story_flow: PackedScene = preload("res://story/day1.tscn")


# GlobalState.gd  (add this helper)
func apply_choice_effects(ch: Choice) -> void:
	# Stats
	mental_health += ch.delta_mental_health
	money         += ch.delta_money
	karma         += ch.delta_karma

	# Flags
	for f in ch.add_flags:    flags[f] = true
	for f in ch.remove_flags: flags.erase(f)

	# Inventory
	for it in ch.add_items:    inventory[it] = (inventory.get(it, 0) + 1)
	for it in ch.remove_items: inventory.erase(it)

	# Optional hook. This means that I can link code execution to a particular choice. Cool!
	if ch.on_select_hook != "" and has_method(ch.on_select_hook):
		call(ch.on_select_hook)
