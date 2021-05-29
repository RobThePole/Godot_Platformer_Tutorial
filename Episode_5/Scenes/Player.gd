extends KinematicBody2D

enum PlayerState{NORMAL,JUMP,FALL,LAND,DIE}
onready var velocity:Vector2 = Vector2.ZERO

const GRAVITY = 800
const JUMP_VELOCITY = -250
const SPEED = 65
const AIR_JUMP_MULT = 0.75
const MAX_FALL_TIME = 0.5

export var air_control = true
export var max_air_jumps = 1

var fall_time = 0
var air_jumps = max_air_jumps
var state:int = PlayerState.NORMAL
var prev_state:int = PlayerState.NORMAL


func horizontal():
	if Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
	else:
		velocity.x = 0
		
	if is_on_floor() and state == PlayerState.NORMAL:
		if velocity.x == 0:
			$AnimationPlayer.play("Idle")
		elif velocity.x > 0:
			$AnimationPlayer.play("Walk_Right")
		elif velocity.x < 0 : 
			$AnimationPlayer.play("Walk_Left")

func Jump():
	
	if air_control:
		horizontal()
		if Input.is_action_pressed("ui_up") and air_jumps:
			if air_jumps == max_air_jumps:
				velocity.y = JUMP_VELOCITY
			else:
				velocity.y = JUMP_VELOCITY * AIR_JUMP_MULT
		air_jumps -= 1
	elif is_on_floor() and velocity.y >= 0:
		change_state(PlayerState.LAND)
	pass

func change_state(new_state: int):
	prev_state = state
	state = new_state	
	
func _physics_process(delta):
	
	horizontal()
	Jump()
	
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity,Vector2.UP,true)
	
	pass
