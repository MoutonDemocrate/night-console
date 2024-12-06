@tool
extends Label
class_name ConsolePointerLabel

@export var deco := ""
@export var initial_text : String
@export var selected : bool :
	set(b) :
		selected = b
		if selected :
			text = deco + initial_text + " ◀"
		else :
			text = deco + initial_text
		#print("Selected of ",self.name," set to ",b)
	
func _ready() -> void:
	if text != "":
		initial_text = text
	selected = false
