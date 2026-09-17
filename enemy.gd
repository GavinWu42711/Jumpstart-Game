extends CharacterBody2D

class_name Enemy

@onready var attack_hitbox:Area2D = $Area2D
@export var health:int = 100
@export var attack_damage:int = 5
var alive:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if alive:
		check_hitbox()
	
func die():
	self.queue_free()
	
func take_damage(damage:int):
	health -= damage
	if health <= 0:
		alive = false
		die()
	
func check_hitbox():
	for body in attack_hitbox.get_overlapping_bodies():
		if body is Player:
			body.take_damage(attack_damage)
