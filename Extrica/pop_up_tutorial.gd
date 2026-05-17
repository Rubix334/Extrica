extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	position = Vector2(0,350)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func animate_on_screen():
	if not visible: 
		var tween = get_tree().create_tween()
		tween.tween_property(self,"position",Vector2(0,0),0.5).set_ease(Tween.EASE_IN_OUT)
		visible = true

func animate_off_screen():
	if visible: 
		var tween = get_tree().create_tween()
		tween.tween_property(self,"position",Vector2(0,350),0.5).set_ease(Tween.EASE_IN_OUT)
		visible = false
