extends Node3D

@onready var racer_scene = preload("res://racer.tscn")
@onready var track = $Track/StaticBody3D2/NavigationRegion3D/MeshInstance3D
@onready var track_points = $Track/Path3D
@onready var button = $Control/Button


func _ready():
	await get_tree().physics_frame
	for i in range (5):
		var racer =  racer_scene.instantiate()

		racer.position = Vector3(i,0,0)
		add_child(racer)
		racer.has_arrived.connect(_on_has_arrived)
		racer.set_movement_target(track_points.curve.get_point_position(racer.point_idx))



func _process(_delta):
	pass

func _on_button_pressed():
	var racers = get_tree().get_nodes_in_group('racers')
	for racer in racers:
		racer.point_idx = 0
		racer.set_movement_target(track_points.curve.get_point_position(racer.point_idx))
		print('Racer has been reset.')

func _on_has_arrived(racer):
	racer.point_idx += 1
	if racer.point_idx < track_points.curve.point_count:
		racer.set_movement_target(track_points.curve.get_point_position(racer.point_idx))
		print("Racer has arrived")
	else:
		print("Racer finished")
