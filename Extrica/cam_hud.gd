extends Control
@export var cam_num : int = 1
@onready var cam_name: Label = $name
@onready var time_label: Label = $time_label
@onready var timer: Timer = $Timer
@onready var noisemaker: Label = $noisemaker
@onready var ani: AnimationPlayer = $AnimationTree
@onready var door: Label = $door

var sec = 0
var min = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cam_name.text = "CAM "+str(cam_num)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if sec > 9:
		if min > 9:
			time_label.text = "00:"+str(min)+":"+str(sec)
		time_label.text = "00:0"+str(min)+":"+str(sec)
	elif not sec > 9:
		if min > 9:
			time_label.text = "00:"+str(min)+":0"+str(sec)
		time_label.text = "00:0"+str(min)+":0"+str(sec)
	if noisemaker.visible==true:
		ani.play("fade out")
		await get_tree().create_timer(3).timeout
		noisemaker.visible=false
		ani.play("RESET")
	if door.visible==true:
		ani.play("fade out_2")
		await get_tree().create_timer(3).timeout
		door.visible=false
		ani.play("RESET")

func _on_timer_timeout() -> void:
	sec += 1
	if sec > 59:
		sec = 0
		min += 1
