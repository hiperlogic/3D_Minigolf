extends RigidBody

signal stopped
signal out_of_field


func shoot(angle, power):
	var force = Vector3(0,0,-2).rotated(Vector3(0,1,0), angle)
	apply_impulse(Vector3(), force*power/5)
	
func _integrate_forces(state):
	if state.linear_velocity.length()<0.1:
		emit_signal("stopped")
		state.linear_velocity = Vector3()
	if sleeping:
		state.linear_velocity = Vector3()

func full_stop():
	self.sleeping = true

func revive():
	self.sleeping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
