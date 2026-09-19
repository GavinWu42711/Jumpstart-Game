extends CharacterBody2D

class_name Boss

@onready var attack_hitbox:Area2D = $Area2D
@onready var health_bar:ProgressBar = $ProgressBar
@export var health:int = 200
@export var attack_damage:int = 20
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
	Global.score += 100
	get_tree().change_scene_to_file("res://scenes/WinScreen.tscn")
	
func take_damage(damage:int):
	health -= damage
	if health <= 0:
		alive = false
		die()
	
func check_hitbox():
	for body in attack_hitbox.get_overlapping_bodies():
		if body is Player:
			body.take_damage(attack_damage)
