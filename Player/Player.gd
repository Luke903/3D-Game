extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SCROLL_SPEED = 1.0
const MOUSE_SENSITIVITY = 0.002
const MOUSE_RANGE = 1.2

var health = 5
var can_drop = true

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")



func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$Pivot.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -MOUSE_RANGE, MOUSE_RANGE)
	if event.is_action_pressed("Pickup") and can_drop:
		for w in $Pivot/Weapon.get_children():
			if w.has_method("drop"):
				w.drop()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("Switch"):
		if $Overhead.current:
			$Pivot/Camera.current = true
		else:
			$Overhead.current = true
			
		

	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("Shoot"):
		var weapons = $Pivot/Weapon
		for w in weapons.get_children():
			if w.has_method("Shoot"):
				w.shoot()

	move_and_slide()


func pickup(weapon):
	can_drop = false 
	$Pickup_Timer.start
	$Pivot/Weapon.add_child(weapon)


func _on_pickup_timer_timeout():
	can_drop = true 

func damage():
	health -=1
	if health <=0:
		get_tree().change_scene_to_file("res://Ui/end_game.tscn")
