extends Node3D

@export var sound_range: float = 8
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var glow_mesh: MeshInstance3D = $MeshInstance3D/MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area3D/CollisionShape3D.shape.radius = sound_range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_audio():
	audio_player.play()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Enemy and audio_player.playing:
		body.hear_noise(global_position)
