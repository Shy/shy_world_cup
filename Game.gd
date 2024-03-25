extends Node3D

@onready var racer_scene = preload("res://racer.tscn")
@onready var track = $Track/StaticBody3D2/NavigationRegion3D/MeshInstance3D
@onready var button = $Control/Button
@onready var navAgent = $Racer/NavigationAgent3D

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().physics_frame
	get_tree().call_group('racers','set_movement_target',Vector3(0,0,0))
	randomize()

func _process(delta):
	if navAgent.is_navigation_finished():
		button.disabled = false
	else:
		button.disabled =  true
	
func _on_button_pressed():
	var new_vector = Vector3(randf_range(0, track.scale.x),0,randf_range(0, track.scale.z))
	button.text = str(new_vector) 
	get_tree().call_group('racers','set_movement_target',new_vector)
