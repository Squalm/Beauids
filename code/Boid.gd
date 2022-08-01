extends Node2D


export var limit = 15
export var push = 30
export var centerpull = 0.05 # cohesion
export var align = 0.05
export var time = 1.0
export var vision = 15
export var boundary = 300
export var edgeforce = 1.0
export var sin_type = false

var V = Vector2(randf()-0.5, randf()-0.5) * limit
var species = 0
var elapsed = 0.0

# BEHAVIOUR

func s(A, B) -> float:
	var components = Vector2(A.x - B.x, A.y - B.y)
	
	return sqrt(pow(components.x, 2.0) + pow(components.y, 2.0))

func nearby(radius) -> Array:
	var near = []
	for b in get_parent().get_children():
		if s(position, b.position) <= radius and b.position != position:
			near.push_back(b)
	return near

func separation(near):
	var best = Vector2(position.x + 1000.0, position.y + 1000.0)
	for b in near:
		if s(position, b.position) < s(position, best):
			best = b.position
	
	if len(near):
		V.x += push * (position.x - best.x) / pow(s(position, best), 2.0)
		V.y += push * (position.y - best.y) / pow(s(position, best), 2.0)

func cohesion(near):
	var center = Vector2(0.0, 0.0)
	var anti_center = Vector2(0.0, 0.0)
	var counts = [0, 0]
	for b in near:
		if species == b.species:
			center += b.position
			counts[0] += 1
		else:
			anti_center += b.position
			counts[1] += 1
	
	if counts[0]:
		center /= counts[0]
		V.x += (center.x - position.x) * centerpull
		V.y += (center.y - position.y) * centerpull
	
	if counts[1]:
		anti_center /= counts[1]
		V += (position - anti_center) * centerpull

func alignment(near):
	var avg_speed = Vector2(0.0, 0.0)
	var count = 0
	for b in near:
		if b.species == species:
			avg_speed += b.V
			count += 1
	
	if count:
		avg_speed /= count
		
		V.x += avg_speed.x * align
		V.y += avg_speed.y * align

func manage():
	# Prevent from running away too far
	if abs(position.x) > boundary:
		V.x += edgeforce * (boundary * sign(position.x) - position.x)
	if abs(position.y) > boundary:
		V.y += edgeforce * (boundary * sign(position.y) - position.y)
	
	# Speedlimit
	var speed = sqrt(pow(V.x, 2.0) + pow(V.y, 2.0))
	if speed > limit:
		V.x = V.x * limit/speed
		V.y = V.y * limit/speed

func _ready():
	emit_signal("draw")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var near = nearby(vision)
	
	separation(near)
	cohesion(near)
	alignment(near)
	manage()
	update()
	
	elapsed = elapsed + delta
	if sin_type:
		var sin_time = sin(elapsed*time)/2+0.5
		position += V * sin_time * delta
	else:
		position += V * time * delta
	

func _draw():
	var nearer = nearby(vision)
	for b in nearer:
		draw_line(Vector2(0,0) , b.position-position, Color(1,1,1, 1-s(position, b.position) / vision), 1.0, true)
