extends Node2D


# Declare member variables here. 
export var no_species = 2

var boid_scene = preload("res://scenes/Boid.tscn")
var colors = [Color(1, 0, 0), Color(0, 1, 0), Color(0, 0, 1), Color(0, 1, 1), Color(1, 0, 1), Color(1, 1, 0)]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var boid_new = boid_scene.instance()
		boid_new.position = get_local_mouse_position()
		var species = int(rand_range(0.0, no_species))
		boid_new.modulate = colors[species]
		# Must be a better way to do this:
		boid_new.species = species
		add_child(boid_new)
		
