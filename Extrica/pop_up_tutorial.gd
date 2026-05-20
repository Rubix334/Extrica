extends Control
@onready var label: Label = $ColorRect/VBoxContainer/Label
var on_screen = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_screen = false
	position = Vector2(0,370)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if on_screen == true and Input.is_action_just_pressed("space"):
		animate_off_screen()

func animate_on_screen():
	if not on_screen: 
		var tween = get_tree().create_tween()
		tween.tween_property(self,"position",Vector2(0,0),0.5).set_ease(Tween.EASE_IN_OUT)
		on_screen = true

func animate_off_screen():
	if on_screen: 
		var tween = get_tree().create_tween()
		tween.tween_property(self,"position",Vector2(0,1000),0.5).set_ease(Tween.EASE_IN_OUT)
		on_screen = false

func change_text(text:String):
	label.text = text
