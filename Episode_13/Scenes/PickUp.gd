extends Area2D

export (bool) var anim_random_start = false
export (bool) var delete_on_pickup = true
export (String) var Name = ""

func _ready():
	if anim_random_start:
		var rnd_start = $AnimationPlayer.current_animation_length * randf()
		$AnimationPlayer.advance(rnd_start)
	pass # Replace with function body.


# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().call_group("game","on_pickup",self)
	if delete_on_pickup:
		queue_free()
	pass # Replace with function body.


func _on_PickUp_body_entered(body):
	if body.name == "Player":
		$AnimationPlayer.play("Pick_up")
	pass # Replace with function body.
