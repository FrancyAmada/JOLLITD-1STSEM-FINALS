extends Summon

class_name JollibeeKnightCrew


func _physics_process(delta):

	if direction != Vector2.ZERO:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()
