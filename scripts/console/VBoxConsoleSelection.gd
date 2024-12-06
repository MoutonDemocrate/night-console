extends VBoxContainer
class_name VBoxConsoleSelection

signal pointer_selected(index : int)

@export var menu_deco : String = ""
var index : int = 0 :
	set(new) :
		self.get_child(index).selected = false
		if new > len(self.get_children()) :
			index = len(self.get_children())
		else :
			if new < 0 :
				new += len(self.get_children())
			index = new
		self.get_child(index).selected = true

func _ready() -> void:
	index = 0

func add_pointer_label(text : String, deco : String = menu_deco) -> Error :
	var pointer_label := ConsolePointerLabel.new()
	pointer_label.initial_text = text
	pointer_label.deco = deco
	self.add_child(pointer_label)
	return OK

func _input(event: InputEvent):
	if event.is_action_pressed("ui_up") :
		index -= 1
	elif event.is_action_pressed("ui_down") :
		index += 1
	elif event.is_action_pressed("ui_accept") :
		pointer_selected.emit(index)
