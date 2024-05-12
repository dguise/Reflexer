extends CharacterBody2D


const SPEED = 300.0
@onready var cam = $Camera2D
var BULLET = preload("res://Projectile/Projectile.tscn")
var hp = 2

func _ready():
	cam.enabled = is_multiplayer_authority()
	
func _input(event):
	var shoot = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	
	if shoot && event is InputEventMouseButton:
		var dir = (get_global_mouse_position() - global_position).normalized()
		var b = BULLET.instantiate()
		var rotation_angle = atan2(dir.y, dir.x)
		var rotation_degrees = rad_to_deg(rotation_angle)
		
		b.rotation_degrees = rotation_degrees
		b.global_position = global_position	+ dir * 70
		var main = $/root/main
		main.add_child(b)
		
	

func _physics_process(delta):
	if !is_multiplayer_authority():
		return
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

@rpc("any_peer", "call_local")	
func take_damage(dmg):
	hp -= dmg
	
	print(hp)
	
	if hp <= 0:
		print("Dead player")
