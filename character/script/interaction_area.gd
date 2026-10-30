extends Area3D

class_name InteractionArea

var focused_interactable: Interactable

signal interactable_focused
signal interactable_unfocused

func _ready():
	area_entered.connect(focus_interactable)
	area_exited.connect(unfocus_interactable)

func invoke():
	if ! focused_interactable: return
		
	await focused_interactable.invoke()
	
	if !focused_interactable.query_returns_event:
		unfocus_interactable(focused_interactable)

func focus_interactable(area):
	if not area is Interactable || !area.query_returns_event: return
	focused_interactable = area
	interactable_focused.emit()

func unfocus_interactable(area):
	if not area is Interactable: return
	if focused_interactable != area: return
	focused_interactable = null
	interactable_unfocused.emit()
