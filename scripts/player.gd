extends CharacterBody2D

class_name Player

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

var health:int = 100
var invincible:bool = false
var invincibility_length:float = 1
var alive:bool = true
var bullet_scene = preload("res://scenes/Bullet.tscn")
var can_attack:bool = true
var attack_cooldown = 1
var last_dir:int = 1
@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var hp_bar:ProgressBar = $ProgressBar
@onready var gun_sound:AudioStreamPlayer2D = $AudioStreamPlayer2D

func _physics_process(delta: float) -> void:
	if alive:
		#Update HP
		hp_bar.value = health
		
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			last_dir = direction
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
	
		#Handle shooting
		if Input.is_action_pressed("attack"):
			shoot(last_dir)
	
		move_and_slide()
		
		#Check HP of the player
		if health <= 0:
			die()
			
		#Handle player animations
		handle_animation(last_dir)
	
func handle_animation(dir:int):
	if dir == -1:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
		
	if velocity.x != 0:
		sprite.play("run")
	else:
		sprite.play("idle")
	
func shoot(direction:int):
	if can_attack:
		can_attack = false
		var bullet:Bullet = bullet_scene.instantiate()
		bullet.global_position = self.global_position
		bullet.dir = direction
		get_parent().add_child(bullet)
		gun_sound.play()
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true
		
func die():
	alive = false
	sprite.play("die")
	get_tree().change_scene_to_file("res://scenes/DeathScreen.tscn")

func take_damage(damage:int):
	if not invincible:
		invincible = true
		health -= damage
		sprite.play("hurt")
		await get_tree().create_timer(invincibility_length).timeout
		invincible = false
		
		
		
