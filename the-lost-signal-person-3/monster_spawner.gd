
extends Node2D

@export var monster_scene: PackedScene

@export var min_spawn_delay: float = 8.0
@export var max_spawn_delay: float = 20.0

@export var min_visible_time: float = 5.0
@export var max_visible_time: float = 12.0

var current_monster: Node2D = null
var room_active: bool = true
var cycle_id: int = 0


func _ready():
	randomize()
	start_spawning()


func start_spawning():
	cycle_id += 1
	_run_spawn_cycle(cycle_id)


func _run_spawn_cycle(id: int) -> void:

	while room_active and id == cycle_id:

		# Wait a random amount of time
		var delay = randf_range(
			min_spawn_delay,
			max_spawn_delay
		)

		await get_tree().create_timer(delay).timeout

		if not room_active or id != cycle_id:
			return

		# Make the monster appear
		spawn_monster()

		# Keep it visible for a random duration
		var duration = randf_range(
			min_visible_time,
			max_visible_time
		)

		await get_tree().create_timer(duration).timeout

		if not room_active or id != cycle_id:
			return

		# Make the monster disappear
		remove_monster()


func spawn_monster():

	if monster_scene == null:
		push_warning("Monster scene has not been assigned!")
		return

	if is_instance_valid(current_monster):
		return

	var spawn_points: Array[Marker2D] = []

	for child in get_children():
		if child is Marker2D:
			spawn_points.append(child)

	if spawn_points.is_empty():
		push_warning("No spawn points found!")
		return

	# Choose a random spawn point
	var chosen_point = spawn_points.pick_random()

	current_monster = monster_scene.instantiate() as Node2D

	if current_monster == null:
		return

	add_child(current_monster)
	current_monster.global_position = chosen_point.global_position


func remove_monster():

	if is_instance_valid(current_monster):
		current_monster.queue_free()

	current_monster = null


# Called when the player leaves this room
func set_room_active(active: bool):

	room_active = active
	cycle_id += 1

	if not active:
		remove_monster()

	else:
		start_spawning()
