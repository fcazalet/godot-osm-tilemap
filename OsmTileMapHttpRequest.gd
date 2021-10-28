tool
extends HTTPRequest
class_name OsmTileMapHttpRequest

signal tile_received(texture, tile_pos)

var _tile_pos : Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("request_completed", self, "_on_OsmTileMapHttpRequest_request_completed")


func query_position(base_url, tile_pos: Vector2, osm_zoom : int, osm_pos : Vector2):
	_tile_pos = tile_pos
#	var url = "https://a.tile.openstreetmap.org/%d/%d/%d.png" % [osm_zoom, osm_pos.x, osm_pos.y]
	var url = base_url + "/%d/%d/%d.png" % [osm_zoom, osm_pos.x, osm_pos.y]
	var http_error = request(url)
	if http_error != OK:
		print("An error occurred in the HTTP request.")


func _on_OsmTileMapHttpRequest_request_completed(result, response_code, headers, body):
	var image = Image.new()
	var image_error = image.load_png_from_buffer(body)
	if image_error != OK:
		print("An error occurred while trying to display the image.")
	print("Received tile " + str(_tile_pos))
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	emit_signal("tile_received", texture, _tile_pos)
	queue_free()

