extends HBoxContainer
class_name ConsolePrompt

@onready var prompt_label : Label = $PromptLabel
@onready var line_edit : LineEdit = $LineEdit

var history : Array[String] = []
var index : int = 0

func _ready() -> void:
	prompt_label.text = State.prompt

func _input(event: InputEvent) -> void:
	if line_edit.editable and history :
		if event.is_action_pressed("ui_up") :
			line_edit.text = history[index]
			line_edit.caret_column = len(line_edit.text)
			index = clampi(index + 1, 0, len(history)-1)
		if event.is_action_pressed("ui_down") :
			index = clampi(index - 1, 0, len(history)-1)
			line_edit.text = history[index]
			line_edit.caret_column = len(line_edit.text)
