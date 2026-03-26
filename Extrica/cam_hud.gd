extends Control
@export var cam_num : int = 1
@onready var cam_name: Label = $name
@onready var time_label: Label = $time_label
@onready var timer: Timer = $Timer

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


func _on_timer_timeout() -> void:
	sec += 1
	if sec > 59:
		sec = 0
		min += 1
