extends Label

var timer;

#Displays FPS
func _ready():
	timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout") 
	add_child(timer)
	timer.set_one_shot(false)
	timer.set_wait_time(0.1)
	timer.start()

func _on_timer_timeout():
	self.text = String(Engine.get_frames_per_second())
