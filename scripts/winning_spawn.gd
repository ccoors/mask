extends Node2D

const Katzenfutter = preload("res://scenes/items/katzenfutter.tscn")

var timer
var radius = 1600

func _init():
	if timer:
		timer.stop()
	timer = Timer.new()
	add_child(timer)
	timer.autostart = true
	timer.wait_time = 60
	timer.timeout.connect(spawn_catfood)


func spawn_catfood():
	var pos = get_node("/root/Main/player").position
	for i in range(8):
		var spawn_angle = i * 45
		var node = Katzenfutter.instantiate()
		node.position.x = pos.x + cos(deg_to_rad(spawn_angle)) * radius
		node.position.y = pos.y + sin(deg_to_rad(spawn_angle)) * radius
		add_child(node)
	print("Timed out!")
