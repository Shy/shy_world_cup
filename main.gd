extends Node3D

@onready var racer_scene = preload("res://racer.tscn")
@onready var track= get_node("Track/Path3D/PathFollow3D")

@export var speed =.1

func _ready():
	var racer = racer_scene.instantiate()
	track.add_child(racer)
	track.progress_ratio = 0 

func _process(delta):
	track.progress_ratio += delta * speed


func _on_button_pressed():
		pass
	
