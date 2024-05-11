extends Area2D

const SPEED = 300

func _process(delta):
	position += Vector2.RIGHT.rotated(rotation) * SPEED * delta


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage.rpc(1)
