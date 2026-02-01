extends Node2D

var timer

func _init():
	timer = Timer.new()
	add_child(timer)
	timer.autostart = true
	timer.wait_time = 0.5
	timer.timeout.connect(_timeout)


func _timeout():
	print("Timed out!")
