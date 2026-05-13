extends Control
@onready var player: Player = $".."
@onready var eye_icon: TextureRect = $Eye_icon
const NOT_SEEN_ICON = preload("uid://bwyotkd81qy7j")
const SEEN_ICON = preload("uid://cywpg7wj1pe7k")
@onready var label: Label = $label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.game_over_hud.visible == true or player.camera.current != true:
		visible = false
	
	if Global.player_in_view:
		eye_icon.set_texture(SEEN_ICON)
	else:
		eye_icon.set_texture(NOT_SEEN_ICON)
