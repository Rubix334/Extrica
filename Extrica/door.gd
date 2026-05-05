extends StaticBody3D
class_name door
@export var locked = false
@onready var glow_mesh: MeshInstance3D = $glow_mesh

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(locked)

func change_lock_status():
	locked = !locked


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		if not locked:
			var tween = get_tree().create_tween()
			tween.tween_property($MeshInstance3D,"position",Vector3(2,-0.08,0.3),1)
			var tween2 = get_tree().create_tween()
			tween2.tween_property($CollisionShape3D,"position",Vector3(2,1.287,-0.098),1)


func _on_area_3d_body_exited(body: Node3D) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($MeshInstance3D,"position",Vector3(0,0,0),1)
	var tween2 = get_tree().create_tween()
	tween2.tween_property($CollisionShape3D,"position",Vector3(0,0,0),1)
