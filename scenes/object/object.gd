extends Area2D

##################################################
const BOUNDARY_SIZE: Vector2 = Vector2(360.0, 360.0)
const MOVING_SPEED: float = 10.0

var diagonal_directions: Array = [
	Vector2(-1, 1), Vector2(-1, -1), Vector2(1, 1), Vector2(1, -1)
	]
var velocity: Vector2 = Vector2.ZERO

##################################################
func _ready() -> void:
	diagonal_directions.shuffle()
	velocity = diagonal_directions.front().normalized() * MOVING_SPEED
	
	area_entered.connect(_on_area_entered)

##################################################
func _process(delta: float) -> void:
	position += velocity * delta
	
	if position.x <= 0.0 or position.x >= BOUNDARY_SIZE.x:
		velocity.x *= -1
	if position.y <= 0.0 or position.y >= BOUNDARY_SIZE.y:
		velocity.y *= -1

##################################################
func _on_area_entered(area: Area2D) -> void:
	if area is Area2D:
		velocity = -velocity
		if area.has_method("bounce_velocity"):
			area.bounce_velocity()

##################################################
func bounce_velocity() -> void:
	velocity = -velocity
