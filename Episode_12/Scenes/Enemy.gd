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
	
	
	pass


func bounce():
	velocity.y = -100


func _on_TopChecker_body_entered(body):
	pass # Replace with function body.


func _on_SideChecker_body_entered(body):
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	pass # Replace with function body.
