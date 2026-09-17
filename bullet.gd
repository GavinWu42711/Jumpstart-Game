extends Node2D

class_name Bullet

@onready var attack_hitbox = $Area2D
var attack_damage = 20
var bullet_speed = 500
var dir = 1
var alive = true
var timeout = 10
@onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = timeout
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if alive:
		check_hitbox()
		self.position.x += bullet_speed * dir * delta
	
func check_hitbox():
	for body in attack_hitbox.get_overlapping_bodies():
		if body is Enemy:
			body.take_damage(attack_damage)
			alive = false
			break
	
	if not alive:
		self.queue_free()

func _on_timer_timeout() -> void:
	alive = false
	self.queue_free()
