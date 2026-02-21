extends Control

@export var max_points: int = 120
@export var padding: float = 16.0
@export var point_radius: float = 4.0

var values: Array[float] = []
var min_y: float = 0.0
var max_y: float = 1.0

func _ready() -> void:
	# stay above panels if needed
	z_index = 10
	set_anchors_preset(Control.PRESET_FULL_RECT)
	
	# Debug: check if we have size
	await get_tree().process_frame
	print("Graph size: ", size)
	print("Graph global pos: ", global_position)
	print("Bank history: ", Global.bank_history)

	# live updates
	Global.bank_changed.connect(_on_bank_changed)

func _on_bank_changed(new_bank: float) -> void:
	values = Global.bank_history.duplicate()
	if values.size() > max_points:
		values = values.slice(values.size() - max_points, values.size())
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
		var m := (max_y - min_y) * 0.1
		min_y -= m
		max_y += m

func _draw() -> void:
	# background
	draw_rect(Rect2(Vector2.ZERO, size), Color(0, 0, 0, 0.25), true)

	if size.x <= 2.0 * padding or size.y <= 2.0 * padding:
		return

	var inner := Rect2(Vector2.ZERO, size).grow(-padding)

	# axes
	draw_line(
		Vector2(inner.position.x, inner.position.y + inner.size.y),
		Vector2(inner.position.x + inner.size.x, inner.position.y + inner.size.y),
		Color(1, 1, 1, 0.5),
		2.0
	)
	draw_line(
		Vector2(inner.position.x, inner.position.y),
		Vector2(inner.position.x, inner.position.y + inner.size.y),
		Color(1, 1, 1, 0.5),
		2.0
	)

	if values.is_empty():
		return

	# scatter points (fixed x spacing by max_points so early dots don't jump to far right)
	var n := values.size() 
	for i in range(n):
		var x_t : float = float(i) / max(float(n-1), 1.0)
		var x := inner.position.x + x_t * inner.size.x
		var v = values[i]
		var yn : float = (v - min_y) / (max_y - min_y)
		yn = clamp(yn, 0.0, 1.0)
		var y = inner.position.y + (1.0-yn) * inner.size.y
		draw_circle(Vector2(x,y), point_radius, Color(1,1,1,1))
