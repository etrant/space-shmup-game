extends Enemy


@export var Bullet : PackedScene
@export var reload_time : float = 2
@export var shots : float = 100
@export var arcs_in_burst : int = 4
@export var time_between_shots_in_burst : float = .1
@onready var rotation_tracker : float
@onready var reload_timer = $Reload_Timer
@onready var burst_timer = $Burst_Timer
@onready var target

func _ready():
	await(get_tree().process_frame)
	target = find_target()
	burst_timer.wait_time = time_between_shots_in_burst
	reload_timer.wait_time = reload_time
	reload_timer.start()

func _physics_process(_delta):
	if target != null:
		rotation_tracker = global_position.direction_to(target.global_position).angle()

	
func shoot():
	for n in arcs_in_burst:
		for shot in (shots/2):
			var inst = Bullet.instantiate()
			get_tree().current_scene.add_child(inst)
			inst.global_position = global_position
			
			var inst2 = Bullet.instantiate()
			get_tree().current_scene.add_child(inst2)
			inst2.global_position = global_position
			
			inst.global_rotation = rotation_tracker - (shot / (shots/2) * PI/24)
			inst2.global_rotation = rotation_tracker + (shot/ (shots/2) * PI/24)
		burst_timer.start()
		await(burst_timer.timeout)

	
func find_target():
	var new_target: Node2D = null
	
	if get_tree().has_group("Player"):
		new_target = get_tree().get_nodes_in_group("Player")[0]
		
	return new_target



func _on_timer_timeout():
	shoot()
	reload_timer.start()