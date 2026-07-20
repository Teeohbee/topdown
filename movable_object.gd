class_name MovableObject
extends CharacterBody2D

func _physics_process(delta: float) -> void:
	move_and_slide()

func apply_impact(impact_veclocity: Vector2) -> void:
	velocity = impact_veclocity
