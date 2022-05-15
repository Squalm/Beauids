extends Node2D


# Declare member variables here. Examples:
export var no_points = 20
export var boundary = 300

var points = []
var radius = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0, no_points):
		points.push_back(Vector2((randf() - 0.5) * boundary, (randf() - 0.5) * boundary))

func square_s(A, B) -> float:
	return pow(A.x - B.x, 2.0) + pow(A.y - B.y, 2.0)

func _on_Spawner_get_boids(boids) -> void:
	for p in points:
		draw_circle(p, radius, Color(1,1,1))
	
	for b in boids:
		var pos = b.position
		var best = [Vector2(0,0), 1000, Vector2(0,0), 1000] # some high number
		for p in points:
			var s = square_s(p, pos)
			if s < best[1]:
				best = [pos, s, best[0], best[1]]
			elif s < best[3]:
				best = [best[0], best[1], pos, s]
		draw_line(best[0], best[2], Color(1, 1, 1, 0.05))
