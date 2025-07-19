extends Node2D

##################################################
const BOUNDARY_SIZE: Vector2 = Vector2(360.0, 360.0)
const OBJECT_SCENE: PackedScene = preload("res://scenes/object/object.tscn")
const SPAWN_BATCH_SIZE: int = 100

var spawn_timer_node: Timer
var frame_log: Dictionary = {}

##################################################
func _ready() -> void:
	spawn_timer_node = $SpawnTimer
	spawn_timer_node.wait_time = 1.0
	spawn_timer_node.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer_node.start()

##################################################
func _on_spawn_timer_timeout() -> void:
	GameManager.set_object_count(GameManager.get_object_count() + SPAWN_BATCH_SIZE)
	for i in range(SPAWN_BATCH_SIZE):
		var object_instance = OBJECT_SCENE.instantiate()
		add_child(object_instance)
		object_instance.global_position = \
		Vector2(randf_range(0.0, BOUNDARY_SIZE.x), randf_range(0.0, BOUNDARY_SIZE.y))
	
	_save_fps_log()

##################################################
func _save_fps_log() -> void:
	frame_log[GameManager.get_object_count()] = Engine.get_frames_per_second()
	
	var file = FileAccess.open("user://fps_log.txt", FileAccess.WRITE)
	if file:
		for sec in frame_log.keys():
			file.store_line("%d, %d" % [sec, frame_log[sec]])
		file.close()
