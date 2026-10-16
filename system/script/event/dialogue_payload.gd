extends Object

class_name DialoguePayload

var line : String
var actor : String
var dialogue_area_index: int
var await_input : bool
var close_timer : float
var await_close : bool
var talk: bool

func _init(line: String, actor: String, await_input: bool, close_timer: float, await_close: bool, talk: bool, dialogue_area_index: int):
	self.line = line
	self.actor = actor
	self.await_input = await_input
	self.await_close = await_close
	self.close_timer = close_timer
	self.talk = talk
	self.dialogue_area_index = dialogue_area_index

static func from_task(task: Task):
	return DialoguePayload.new(task.get_input("text"), task.get_input("actor"), task.get_input("await_input"), task.get_input("close_timer"), task.get_input("await_close"), task.get_input("talk"), task.get_input("dialogue_area_index"))
