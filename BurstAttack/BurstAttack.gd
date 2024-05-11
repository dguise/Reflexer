extends Area2D

const explosion = preload("res://Explosion.tscn")

const DAMAGE = 1


func _ready():
	await get_tree().create_timer(1).timeout
	explode()

func explode():
	visuals()
	
	print("explosion yeee")
	
	var bodies = get_overlapping_bodies()
	
	if bodies.size() > 0:
		for bod in bodies:
			if bod.has_method("take_damage"):
				bod.take_damage(DAMAGE)


func visuals():
	var particles = explosion.instantiate() as GPUParticles2D
	var player = get_parent() as Node2D
	particles.emitting = true
	get_parent().add_child(particles)
	print("boom")
