extends MultiplayerSpawner

const COOLDOWN = 10_000 # ms
var next_cast = 0

var burst_attack = preload("res://BurstAttack.tscn")

func _process(delta):
	var input = Input.is_key_pressed(KEY_Q)
	
	if input && Time.get_ticks_msec() > next_cast:
		print("exploding")
		next_cast = Time.get_ticks_msec() + COOLDOWN
		spawn(burst_attack)


func _init():
	spawn_function = spawn_burst


func spawn_burst(data):
	var burst = burst_attack.instantiate() as Area2D
	burst.position = Vector2(0, 0)
