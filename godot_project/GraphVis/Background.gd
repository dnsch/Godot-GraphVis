extends ColorRect

var gvis = GRAPHVIS.new()
var file_name

var window_size = OS.get_window_size()

func _ready():
	rect_size = window_size
	file_name = 'graphs/simple_bowtie'
	gvis.graph_read_file(file_name)
	gvis.draw_pos_random(window_size.x, window_size.y)
	var array = [.1, .2, .3, .4, .5, .6, .7, .8, .9, .10, .11]
	var array_width = 10
	var array_heigh = 1
	var byte_array = PoolByteArray(array)
	var img = Image.new()
	img.create_from_data(array_width, array_heigh, false, Image.FORMAT_R8, byte_array)
	var texture = ImageTexture.new()
	texture.create_from_image(img, 0)
	material.set_shader_param("my_array", texture)
	material.set_shader_param("array", texture)
	pass

