extends StaticBody2D




func _on_Area2D_body_entered(body):
	
	
	if body.name == "Player":
		
		if body.position.x - self.position.x > 0:
			body.position = self.position - Vector2(1,0)
		elif body.position.x -self.position.x < 0:
			body.position = self.position + Vector2(1,0)
		
	
	pass # Replace with function body.
