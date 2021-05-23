extends KinematicBody2D

onready var velocity:Vector2 = Vector2.ZERO

const GRAVITY = 800
const JUMP_VELOCITY = -250
const SPEED = 65

func horizontal():
	if Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
	else:
		velocity.x = 0

func Jump():
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func _physics_process(delta):
	
	horizontal()
	Jump()
	
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity,Vector2.UP,true)
	
	pass
