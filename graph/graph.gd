extends Control

@export var max_points := 60
@export var padding := 16.0

var values: Array[float] = []
var min_y := 0.0
var max_y := 1.0

func add_point(balance: float) -> void:
	values.append(balance)
	if values.size() > max_points:
		values.pop_front()
	_recompute_range()
	queue_redraw()

func _recompute_range() -> void:
	if values.is_empty():
		min_y = 0.0
		max_y = 1.0
		return
	min_y = values.min()
	max_y = values.max()
	if is_equal_approx(min_y, max_y):
		max_y = min_y + 1.0
	else:
		var m = (max_y - min_y) * 0.1
		min_y -= m
		max_y += m

func _draw() -> void:
	var r := Rect2(Vector2.ZERO, size)
	var inner := r.grow(-padding)

	draw_rect(r, Color(0,0,0,0.25), true)

	if values.size() < 2:
		if values.size() == 1:
			draw_string(get_theme_default_font(), inner.position + Vector2(0, 14),
				"($%.2f)" % values[0])
		return

	# axes
	draw_line(Vector2(inner.position.x, inner.position.y + inner.size.y),
		Vector2(inner.position.x + inner.size.x, inner.position.y + inner.size.y),
		Color(1,1,1,0.5), 2)
	draw_line(Vector2(inner.position.x, inner.position.y),
		Vector2(inner.position.x, inner.position.y + inner.size.y),
		Color(1,1,1,0.5), 2)

	# points
	var pts: PackedVector2Array = []
	var n := values.size()
	for i in range(n):
		var t := float(i) / float(n - 1)
		var x := inner.position.x + t * inner.size.x

		var v := values[i]
		var yn := (v - min_y) / (max_y - min_y)
		var y := inner.position.y + (1.0 - yn) * inner.size.y
		pts.append(Vector2(x, y))

	draw_polyline(pts, Color(0.3, 0.9, 1.0, 1.0), 3.0, true)
	for p in pts:
		draw_circle(p, 3.5, Color.WHITE)

	var last := n - 1
	draw_string(get_theme_default_font(), pts[last] + Vector2(8, -8),
		"(%d, $%.2f)" % [last, values[last]], HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color.WHITE)
