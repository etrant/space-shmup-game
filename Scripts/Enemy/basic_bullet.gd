extends Area2D

@export var speed : float = 300
@export var damage : float = 1
const RIGHT = Vector2.RIGHT


func _physics_process(delta):
	position += RIGHT.rotated(rotation) * speed * delta
		
	
func _on_body_entered(body):
	if body.name == "Player":
		await(body.hit())
		queue_free()
		

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
