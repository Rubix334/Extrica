extends Node3D
@onready var enemy_npc: Enemy = $EnemyNPC
@onready var tutorial_popup: Control = $tutorial_popup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_npc.PROCESS_MODE_DISABLED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_outer_hallway_area_body_entered(body: Node3D) -> void:
	if body is Player:
		print("entered")
		enemy_npc.PROCESS_MODE_ALWAYS
		tutorial_popup.change_text("There is an enemy nearby, take cover to avoid their sight.
		 There are threats that will try to stop you in your escape. You may not be able to
		 physically fight back, but you do have tools to help you avoid them.")
		tutorial_popup.animate_on_screen()
		$outer_hallway_area.global_position = Vector3(0,0,-500)
