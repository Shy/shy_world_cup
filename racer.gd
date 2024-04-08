extends CharacterBody3D

var movement_speed: float = 2.0
var point_idx = 0
var stopped = false
var drag_factor = 0.05


@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

signal has_arrived()

func _ready():
	## These values need to be adjusted for the actor's speed
	## and the navigation layout.
	navigation_agent.path_desired_distance = 2
	navigation_agent.target_desired_distance =2
	## Make sure to not await during _ready.
	#call_deferred("actor_setup")
#
#func actor_setup():
	## Wait for the first physics frame so the NavigationServer can sync.
	#await get_tree().physics_frame
#
	## Now that the navigation map is no longer empty, set the movement target.
	#set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector3):
	stopped = false
	navigation_agent.set_target_position(movement_target)

func _physics_process(_delta):
	if navigation_agent.is_navigation_finished():
		if !stopped:
			stopped = true
			has_arrived.emit(self)
		return	
	var current_agent_position: Vector3 = global_position
	var next_location: Vector3 = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(next_location)
	var desired_velocity = direction * movement_speed
	var steering_vector = desired_velocity - navigation_agent.velocity
	#rotate(Vector3(0,1,0), navigation_agent.velocity.angle_to(direction))
	#velocity = (next_location - current_agent_position).normalized() * movement_speed
	if navigation_agent.velocity != Vector3.ZERO:
		var lookdir = atan2(-navigation_agent.velocity.x, -navigation_agent.velocity.z)
		rotation.y = lerp(rotation.y, lookdir, 0.1)
	navigation_agent.velocity += steering_vector * drag_factor


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward((safe_velocity),.25)
	move_and_slide()

	
