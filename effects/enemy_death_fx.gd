extends Node2D

func _ready():
	if Prefs.gpuParticles:
		$GPUParticles2D.show()
		$GPUParticles2D.emitting = true
	else:
		$CPUParticles2D.show()
		$CPUParticles2D.emitting = true
