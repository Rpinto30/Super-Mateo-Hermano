extends CharacterBody2D

#EXPORT
@export var sprite: AnimatedSprite2D
#LINEAR VELOCITY 
var VELOCITY : float = 80
const MAX_SPEED : float = 210.0

var DESACELERATION : float = MIN_DESC
const MIN_DESC : float = 335.0
const MAX_DESC : float = 1000

const timer_pulsed_limit : float = 0.25
var timer_pulsed : float = timer_pulsed_limit

const timer_stop_limit : float = 0.8
var timer_stop: float = timer_stop_limit
var on_stop : bool = false
var actual_direction : float = 1.0

#JUMP
var after_jump : bool = false
var can_jump : bool
const max_timer_jump : float = 2.3
const min_jump_force : float = 185
var timer_jump : float = max_timer_jump

func _physics_process(delta: float) -> void:
	if not is_on_floor() or is_on_ceiling():
		velocity += get_gravity() * delta
		if timer_jump <= 0: 
			after_jump = false
			can_jump = false
		DESACELERATION = MAX_DESC
	else:
		DESACELERATION = MIN_DESC

	if Input.is_action_pressed("ui_accept") and is_on_floor():
		can_jump = true
	elif Input.is_action_just_released("ui_accept") or is_on_ceiling(): can_jump = false
	else:
		if timer_jump > 0: 
			after_jump = true
			timer_jump -= 10* delta
	
	if can_jump: velocity.y = -(min_jump_force) 
	else: 
		timer_jump = max_timer_jump
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if is_on_floor():
			if direction == 1.0: sprite.flip_h = false
			else: sprite.flip_h = true
		
		timer_pulsed = timer_pulsed_limit
		#MOVIMIENTO
		if abs(velocity.x) < (MAX_SPEED* 0.9):  
			#velocity.x = MAX_SPEED * 0.25 * direction
			#else:
			velocity.x += (direction * VELOCITY) * delta
		else:
			pass#velocity.x = direction * MAX_SPEED
		
		if actual_direction != direction: #Frenado
			if abs(velocity.x) >= (MAX_SPEED/2.4):  
				on_stop = true
				velocity.x = move_toward(velocity.x, 0, 4800 * delta)
			timer_stop = timer_pulsed_limit
		else:
			timer_stop -= delta
			if timer_stop <= 0:
				on_stop = false 

		actual_direction = direction #Para detectar el cambio de dirección
	else:
		if timer_pulsed > 0:
			timer_pulsed -= delta
		else:
			velocity.x = move_toward(velocity.x, 0, DESACELERATION * delta)
	
	
	animator_manager()
	move_and_slide()

func animator_manager():
	if is_on_floor():
		if on_stop:
			sprite.play("Stop")
		else:
			if abs(velocity.x) > 0: sprite.play("Move", velocity.x * 0.035)
			else: sprite.play("Idle")
			
	else:
		sprite.play("Jump")
