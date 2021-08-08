extends KinematicBody2D


const GRAVITY = 600
const ACCERLATION = 2000

export var direction = -1
export var detects_cliffs = true

var velocity = Vector2()
var stop = false


# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	if direction == -1:
		$Sprite.flip_h = true
	$FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$FloorChecker.enabled = detects_cliffs
	
	pass # Replace with function body.

func _physics_process(delta):
	
	if is_on_wall() or not $FloorChecker.is_colliding() and detects_cliffs and is_on_floor():
		direction = direction * -1
		$Sprite.flip_h = not $Sprite.flip_h
		$FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
		
	velocity.y += GRAVITY * delta
	
	if direction != 0 and not stop:
		velocity.x = direction * ACCERLATION * delta
		
		
	velocity = move_and_slide(velocity,Vector2.UP)
	
	pass


func bounce():
	velocity.y = -100


func _on_TopChecker_body_entered(body):
	
	if body.name == self.name:
		pass
	elif body.name == "Player":
		stop = true
		velocity.x = 0
		
		$CollisionShape2D.set_deferred("disabled",true)
		$TopChecker/CollisionShape2D.set_deferred("disabled",true)
		$SideChecker/CollisionShape2D.set_deferred("disabled",true)
	
		if body.has_method("bounce"):
			body.change_state(States.PlayerState.BOUNCE)
		$AnimationPlayer.play("death")
	
	pass # Replace with function body.


func _on_SideChecker_body_entered(body):
	if body.name == self.name:
		pass
	else:
		if body.has_method("ouch"):
			body.ouch(self.position.x)
			$TopChecker/CollisionShape2D.set_deferred("disabled",true)
			$SideChecker/CollisionShape2D.set_deferred("disabled",true)
		else:
			direction = direction * -1
			$Sprite.flip_h = not $Sprite.flip_h
			$FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()
	pass # Replace with function body.
