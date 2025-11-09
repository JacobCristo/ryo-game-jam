class_name PostProcessing extends Node2D

@onready var fisheye_shader: ColorRect = $FisheyeBuffer/FisheyeShader
@onready var noise_shader: ColorRect = $NoiseBuffer/NoiseShader
@onready var sobel_shader: ColorRect = $SobelBuffer/SobelShader

func tween_fisheye(intensity: float, zoom: float) -> void:
	var tween = create_tween()
	var mat = fisheye_shader.material as ShaderMaterial
	
	var start_intensity: float = mat.get_shader_parameter("fisheye_intensity")
	var start_zoom: float = mat.get_shader_parameter("zoom")
	
	tween.parallel().tween_method(
		func(value): mat.set_shader_parameter("fisheye_intensity", value),
		mat.get_shader_parameter("fisheye_intensity"),
		intensity,
		0.25
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	
	tween.parallel().tween_method(
		func(value): mat.set_shader_parameter("zoom", value),
		mat.get_shader_parameter("zoom"),
		zoom,
		0.25
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	
	await tween.finished
	tween = create_tween()
	
	tween.parallel().tween_method(
		func(value): mat.set_shader_parameter("fisheye_intensity", value),
		mat.get_shader_parameter("fisheye_intensity"),
		start_intensity,
		0.2
	)
	
	tween.parallel().tween_method(
		func(value): mat.set_shader_parameter("zoom", value),
		mat.get_shader_parameter("zoom"),
		start_zoom,
		0.2
	)

func tween_sobel(intensity: float) -> void:
	var tween = get_tree().create_tween()
	var mat = sobel_shader.material as ShaderMaterial
	
	var start_intensity = mat.get_shader_parameter("intensity")
	
	tween.parallel().tween_method(
		func(value): mat.set_shader_parameter("intensity", value),
		mat.get_shader_parameter("intensity"),
		intensity,
		0.25
	)
	
	await tween.finished
	tween = create_tween()
	
	tween.parallel().tween_method(
		func(value): mat.set_shader_parameter("intensity", value),
		mat.get_shader_parameter("intensity"),
		start_intensity,
		0.2
	)
