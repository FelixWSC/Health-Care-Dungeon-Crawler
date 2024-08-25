extends CharacterBody2D

@export var speed = 100
@export var acceleration = 0.1
@export var friction = 0.0  # Set to 0 to completely remove friction

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
		$AnimatedSprite2D.flip_h = false
	if Input.is_action_pressed('left'):
		input.x -= 1
		$AnimatedSprite2D.flip_h = true
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	return input

func _physics_process(delta):
	var direction = get_input()
	var target_velocity = direction.normalized() * speed

	if direction.length() > 0:
		# Accelerate towards the target velocity
		velocity = velocity.lerp(target_velocity, acceleration)
	else:
		# Apply friction only if you want some deceleration, otherwise, keep it zero
		if friction > 0:
			velocity = velocity.lerp(Vector2.ZERO, friction)
		else:
			velocity = Vector2.ZERO  # Keep velocity at zero if no friction

	# Move the character
	move_and_slide()
