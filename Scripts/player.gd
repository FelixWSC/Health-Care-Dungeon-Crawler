extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true 

var attack_ip = false


@export var speed = 100
@export var acceleration = 0.1
@export var friction = 0.0  # Set to 0 to completely remove friction

@onready var animated_sprite = $AnimatedSprite2D

func get_input() -> Vector2:
	var input = Vector2.ZERO
	
	if Input.is_action_pressed('right'):
		input.x += 1
		animated_sprite.flip_h = false
	if Input.is_action_pressed('left'):
		input.x -= 1
		animated_sprite.flip_h = true
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	
	return input

func _physics_process(delta: float) -> void:
	var direction = get_input()
	enemy_attack()
	
	if health <= 0:
		player_alive = false # You can add death or respawn screen here
		health = 0
		print("player has been killed")
		self.queue_free() 
	
	# Set the animation based on input
	if direction.length() > 0:
		animated_sprite.animation = "run"
	else:
		animated_sprite.animation = "idle"
	
	var target_velocity = direction.normalized() * speed
	
	if direction.length() > 0:
		# Accelerate towards the target velocity
		velocity = velocity.lerp(target_velocity, acceleration)
	else:
		# Apply friction or stop movement
		if friction > 0:
			velocity = velocity.lerp(Vector2.ZERO, friction)
		else:
			velocity = Vector2.ZERO  # Keep velocity at zero if no friction

	# Move the character
	move_and_slide()


func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method ("enemy"):
		enemy_inattack_range = true 
 

func _on_player_hitbox_body_exited(body):
	if body.has_method ("enemy"):
		enemy_inattack_range = false 

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
