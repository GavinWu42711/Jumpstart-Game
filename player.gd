extends CharacterBody2D

class_name Player

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

var health:int = 100
var invincible:bool = false
var invincibility_length:float = 1
var alive:bool = true
var bullet_scene = preload("res://Bullet.tscn")
var can_attack:bool = true
var attack_cooldown = 1

func _physics_process(delta: float) -> void:
	if alive:
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
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
		#Handle shooting
		if Input.is_action_pressed("attack"):
			if direction:
				shoot(direction)
			else:
				shoot(1)
	
		move_and_slide()
		
		#Check HP of the player
		if health <= 0:
			die()
	
func shoot(direction:int):
	if can_attack:
		can_attack = false
		var bullet:Bullet = bullet_scene.instantiate()
		bullet.global_position = self.global_position
		bullet.dir = direction
		get_parent().add_child(bullet)
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true
		
func die():
	alive = false
	print("dead")

func take_damage(damage:int):
	if not invincible:
		invincible = true
		health -= damage
		await get_tree().create_timer(invincibility_length).timeout
		invincible = false
		
		
