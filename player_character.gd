extends CharacterBody2D

@export_range(0, 1000) var speed := 60

func _physics_process(_delta: float) -> void:
	get_player_input()
	if move_and_slide():
		resolve_collisions()

func resolve_collisions() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider() as RigidBody2D
		if body:
			print(body)
			print(collision.get_normal())
			body.apply_force(-100 * collision.get_normal())

func get_player_input() -> void:
	var vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = vector * speed
