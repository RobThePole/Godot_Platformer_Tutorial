extends KinematicBody2D

enum PlayerState{NORMAL,JUMP,FALL,LAND,DIE,NEXT,START}
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
var state:int = PlayerState.START
var prev_state:int = PlayerState.START


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
	
	if Input.is_action_just_pressed("ui_up") and air_jumps >=0:
		if air_jumps == max_air_jumps:
			velocity.y = JUMP_VELOCITY
			jump_anim()
			fall_time = 0
			change_state(PlayerState.JUMP)

		else:
			velocity.y = JUMP_VELOCITY * AIR_JUMP_MULT
			jump_anim()
			fall_time = 0
			change_state(PlayerState.JUMP)

		air_jumps -= 1

	pass

func jump_anim():
	if velocity.x > 0:
		$AnimationPlayer.play("Jump_Right")
	elif velocity.x < 0:
		$AnimationPlayer.play("Jump_Left")
	else:
		var random_choice = randi()%2 + 1
		if random_choice == 1:
			$AnimationPlayer.play("Jump_Right")
		else:
			$AnimationPlayer.play("Jump_Left")
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
	if Input.is_action_pressed("restart"):
		get_tree().call_group("game","load_level")
		
	
		
	match state:
		PlayerState.NORMAL:
			if !is_on_floor():
				change_state(PlayerState.FALL)
			else:
				horizontal()
				Jump()
		PlayerState.JUMP:
			Jump()
			if air_control:
				horizontal()
			if velocity.y >= 1:
				change_state(PlayerState.FALL)
		PlayerState.FALL:
			if air_control:
				horizontal()
			if is_on_floor() and velocity.y >= 0:
				change_state(PlayerState.LAND)
				# Used to fix player rotation when landing can go in
				# and make a new animation for landing here as well
				$AnimationPlayer.play("Idle")
			elif fall_time <= MAX_FALL_TIME:
				Jump()
			
			
			fall_time += delta	
		PlayerState.LAND:
			change_state(PlayerState.NORMAL)
			air_jumps = max_air_jumps
			fall_time = 0
		PlayerState.DIE:
			if prev_state == PlayerState.NEXT:
				self.queue_free()
			else:
				print("POP UP DEATH UI")
				self.queue_free()
		PlayerState.NEXT:
			velocity = Vector2.ZERO
			$AnimationPlayer.play("next_level")
		PlayerState.START:
			$AnimationPlayer.play("start")
			
func change_state(new_state: int):
	prev_state = state
	state = new_state		
func _physics_process(delta):
	
	if state != PlayerState.NEXT:
		velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity,Vector2.UP,true)
	pass
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Jump_Right":
		jump_anim()
	elif anim_name == "Jump_Left":
		jump_anim()
	elif anim_name == "next_level":
		change_state(PlayerState.DIE)
	elif anim_name == "start":
		change_state(PlayerState.NORMAL)
	pass # Replace with function body.
