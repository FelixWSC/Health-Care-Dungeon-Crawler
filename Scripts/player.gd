extends CharacterBody2D

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
