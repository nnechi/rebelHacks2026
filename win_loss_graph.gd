extends Control

@onready var plot_area: Control = $PlotArea
@onready var line: Line2D = $PlotArea/CumulativeLine
@onready var stats_label: Label = $Stats

func _ready():
	StatsManager.game_recorded.connect(_on_game_recorded)
	resized.connect(update_graph)  # Auto-refresh if window resized
	update_graph()

func _on_game_recorded(_result: int):
	update_graph()

func update_graph():
	var cum = StatsManager.cumulative
	if cum.size() <= 1:
		stats_label.text = "Games: 0 | Net: 0"
		line.points = PackedVector2Array()
		return

	var num_games = cum.size() - 1
	stats_label.text = "Games: %d | Net: %d" % [num_games, cum.back()]

	var points = PackedVector2Array()
	var width = plot_area.size.x
	var height = plot_area.size.y

	var min_y = cum.min()
	var max_y = cum.max()
	var y_range = max_y - min_y
	if y_range == 0:
		y_range = 2.0

	for i in range(cum.size()):
		var x = (float(i) / num_games) * width if num_games > 0 else 0.0
		var norm = (cum[i] - min_y) / y_range
		var y = height * (1.0 - norm)  # Higher wins = higher on screen
		points.append(Vector2(x, y))

	line.points = points
