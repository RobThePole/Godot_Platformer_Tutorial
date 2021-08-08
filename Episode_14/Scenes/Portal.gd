extends Area2D

enum PlayerState{NORMAL,JUMP,FALL,LAND,DIE,NEXT}




func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "pick_up":
		get_tree().call_group("game","on_next_level")
		#self.queue_free()



func _on_Portal_body_entered(body):
	if body.name == "Player":
		$AnimationPlayer.play("pick_up")
		body.position = self.position
		body.change_state(PlayerState.NEXT)
	pass # Replace with function body.
