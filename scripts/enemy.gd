extends CharacterBody2D

class_name Enemy

@onready var attack_hitbox:Area2D = $Area2D
@onready var health_bar:ProgressBar = $ProgressBar
@export var health:int = 100
@export var attack_damage:int = 10
@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
var alive:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if alive:
		sprite.play("idle")
		
		#Update hp
		health_bar.value = health
		
		#Check if can attack player
		check_hitbox()
	
func die():
	sprite.play("death")
	Global.score += 10
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


func _on_audio_stream_player_2d_finished() -> void:
	pass # Replace with function body.
