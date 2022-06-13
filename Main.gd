extends Node

var shots = 0
var state 
var power = 0
var power_change = 1
var power_speed = 100
var angle_change = 1
var angle_speed = 1.1

var hole_dir

enum {SET_ANGLE, SET_POWER, SHOOT, WIN}


# Called when the node enters the scene tree for the first time.
###
# Hide the arrow
# Place the ball in the Tee
###
func _ready():
	$Arrow.hide()
	$Ball.transform.origin = $Tee.transform.origin
	change_state(SET_ANGLE)


func change_state(new_state):
	### TODO: Check if the transition is valid
	state = new_state
	match state:
		SET_ANGLE:
			$Arrow.transform.origin = $Ball.transform.origin
			$Arrow.show()
			set_start_angle()
		SET_POWER:
			pass
		SHOOT:
			$Arrow.hide()
			$Ball.shoot($Arrow.rotation.y, power)
			shots += 1
			$UI.update_shots(shots)
		WIN:
			$Ball.hide()
			$Arrow.hide()

func _input(event):
	if event is InputEventMouseMotion:
		if state == SET_ANGLE:
			$Arrow.rotation.y -= event.relative.x/150
	if event.is_action_pressed("click"):
		$Ball.revive()
		match state:
			SET_ANGLE:
				change_state(SET_POWER)
			SET_POWER:
				change_state(SHOOT)
				
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		#SET_ANGLE:
		#	animate_angle(delta)
		SET_POWER:
			animate_power_bar(delta)
		SHOOT:
			pass
			
func animate_power_bar(delta):
	power += power_speed * power_change * delta
	if power >= 100:
		power_change = -1
	if power <= 0:
		power_change = 1
	$UI.update_powerbar(power)


func animate_angle(delta):
	$Arrow.rotation.y += angle_speed * angle_change * delta
	if $Arrow.rotation.y > hole_dir + PI/1.5:
		angle_change = -1
	if $Arrow.rotation.y < hole_dir + -PI/1.5:
		angle_change = 1
		


func set_start_angle():
	var hole_pos = Vector2($Hole.transform.origin.z, $Hole.transform.origin.x)
	var ball_pos = Vector2($Ball.transform.origin.z, $Ball.transform.origin.x)
	hole_dir = (ball_pos - hole_pos).angle()
	$Arrow.rotation.y = hole_dir

func _on_Hole_body_entered(body):
	if body.name == 'Ball':
		print("Win!")
		change_state(WIN)
	pass # Replace with function body.


func _on_Ball_stopped():
	if state == SHOOT:
		change_state(SET_ANGLE)



func _on_Area_body_exited(body):
	if body.name == 'Ball':
		$Ball.full_stop()
		$Ball.transform.origin = $Tee.transform.origin
		$Camera.current = true
		change_state(SET_ANGLE)
	pass # Replace with function body.
