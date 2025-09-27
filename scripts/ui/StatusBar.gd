extends PanelContainer

@onready var item_list := $"MarginContainer/Inventory"
@onready var item_prefab := $"MarginContainer/Inventory/ItemIcon"
@onready var item_blown_up := $"Item Blown Up View"

var all_items: Dictionary = {
	"Shovel": Item.new("Shovel", "A digging instrument.", "shovel.png"),
	"Goomba": Item.new("Goomba", "A super mario guy. White people are jacking off to it.", "goomba.png")
}

# We set items using an Array[String] of the item names, and the result is an Array[Item]
var items: Array[Item] = []

func updateItems(value):
	items = []
	for i in range(value.size()):
		items.append(all_items[value[i]])
	_init_buttons()

func _ready():
	pass

func _init_buttons() -> void:
	# Clear existing dynamic buttons (keep element 0 as a prefab to reuse)
	for i in range(item_list.get_child_count() - 1, 0, -1):
		var btn := item_list.get_child(i)
		btn.queue_free()

	# Also reset and disconnect the first (prefab) button
	var first_btn: Button = item_list.get_child(0)
	#if first_btn.pressed.is_connected(_on_button_pressed_stub):
	#	first_btn.pressed.disconnect(_on_button_pressed_stub)
	first_btn.visible = false
	first_btn.disabled = false

	var added := 0
	for i in items.size():
		var it: Item = items[i]

		# Create or reuse a button for this visible choice
		var b: Button
		if added == 0:
			b = first_btn
		else:
			b = item_prefab.duplicate() as Button
			item_list.add_child(b)

		b.visible = true
		b.disabled = false
		
		var icon = it.icon
		
		# If no icon set, use a placeholder
		if (!icon):
			icon = "shovel.png"
		
		b.icon = load("res://art/item_sprites/{s}".format({"s": icon}))
		b.tooltip_text = it.name

		added += 1

	# If nothing to show, hide the whole panel
	item_list.visible = added > 0
