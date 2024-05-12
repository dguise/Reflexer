extends Area2D

const SPEED = 500

func _ready():
	await get_tree().create_timer(2).timeout
	queue_free()


func _process(delta):
	position += Vector2.RIGHT.rotated(rotation) * SPEED * delta


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage.rpc(1)
