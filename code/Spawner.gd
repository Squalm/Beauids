extends Node2D


# Declare member variables here. 
@export var no_species = 2

var boid_scene = preload("res://scenes/Boid.tscn")
var colors = [Color(1, 0, 0), Color(0, 1, 0), Color(0, 0, 1), Color(0, 1, 1), Color(1, 0, 1), Color(1, 1, 0)]

signal get_boids(boids)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var boid_new = boid_scene.instantiate()
		boid_new.position = get_local_mouse_position()
		var species = int(randf_range(0.0, no_species))
		boid_new.modulate = colors[species]
		# Must be a better way to do this:
		boid_new.species = species
		add_child(boid_new)
	
	#emit_signal("get_boids", get_children())


func _on_SpeciesSlider_value_changed(value: float) -> void:
	no_species = value
	for boid in get_children():
		boid.species = int(randf_range(0.0, no_species))
		boid.modulate = colors[boid.species]


func _on_CohesionSlider_value_changed(value: float) -> void:
	for boid in get_children():
		boid.centerpull = value


func _on_AlignmentSlider_value_changed(value: float) -> void:
	for boid in get_children():
		boid.align = value


func _on_SeparationSlider_value_changed(value: float) -> void:
	for boid in get_children():
		boid.push = value


func _on_VisionSlider_value_changed(value: float) -> void:
	for boid in get_children():
		boid.vision = value


func _on_SpeedSlider_value_changed(value: float) -> void:
	for boid in get_children():
		boid.time = value


func _on_BoundarySlider_value_changed(value: float) -> void:
	for boid in get_children():
		boid.boundary = value
