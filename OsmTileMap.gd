"""
Author: https://github.com/fcazalet

TileMap that download tiles from OpenStreetMap

"""
tool
extends TileMap
class_name OSMTileMap


export var latitude = 40.7893
export var longitude = -73.9619
export var zoom = 11
export var base_url = "https://a.tile.openstreetmap.org"
export var tile_material : ShaderMaterial
var _latitude
var _longitude
var _zoom
var _base_url
var requestScn = preload("res://OsmTileMapHttpRequest.tscn")
var requestPosition: Vector2
var osmPoint: Vector2
var tilemapPoint = Vector2(0,0)
var initialized = false
var loading_tiles = []


func _ready():
	osmPoint = deg2num(latitude, longitude, zoom)


func _process(delta):
	if _longitude != longitude || _latitude != latitude || _zoom != zoom || _base_url != base_url:
		_latitude = latitude
		_longitude = longitude
		_zoom = zoom
		_base_url = base_url
		clear()
		tile_set.clear()
		osmPoint = deg2num(latitude, longitude, zoom)
		tilemapPoint = Vector2(0,0)
#		$Camera2D.position = Vector2(0, 0)
		draw_tiles(tilemapPoint, osmPoint)


func draw_tiles(tilemapPoint, osmPoint):
	for x in range(tilemapPoint.x-3, tilemapPoint.x+3):
		for y in range(tilemapPoint.y-3, tilemapPoint.y+3):
			if not loading_tiles.has(Vector2(x,y)):
				var requestNode = requestScn.instance()
				requestNode.name = "request_"+str(x)+"_"+str(y)
				add_child(requestNode)
				requestNode.connect("tile_received", self, "_on_tile_received")
				requestNode.query_position(_base_url, Vector2(x,y), zoom, osmPoint+Vector2(x,y))
				loading_tiles.append(Vector2(x,y))


func _on_tile_received(texture, tile_pos):
	var tile_id = tile_set.get_last_unused_tile_id()
	tile_set.create_tile(tile_id)
	tile_set.tile_set_texture(tile_id, texture)
	set_cell(tile_pos.x, tile_pos.y, tile_id)
	if tile_material != null:
		tile_set.tile_set_material(tile_id, tile_material)
	loading_tiles.erase(tile_pos)


### UTILS

func rad2num(lat_rad, lon_rad, zoom):
  var n = 2.0 * zoom
  var xtile = int((rad2deg(lon_rad) + 180.0) / 360.0 * n)
  var ytile = int((1.0 - asinh(tan(lat_rad)) / PI) / 2.0 * n)
  return Vector2(xtile, ytile)


func deg2num(lat_deg, lon_deg, zoom):
  var lat_rad = deg2rad(lat_deg)
  var n = pow(2.0 ,zoom)
  var xtile = int((((lon_deg + 180.0) / 360.0)) * n)
  var ytile = int((1.0 - asinh(tan(lat_rad)) / PI) / 2.0 * n)
  return Vector2(xtile, ytile)


func deg2num2(lat_deg, lon_deg, zoom):
	var n = pow(2,zoom)
	var xtile = n * ((lon_deg + 180) / 360)
	var ytile = n * (1 - (log(tan(deg2rad(lat_deg)) + 1/cos(deg2rad(lat_deg))) / PI)) / 2
	return Vector2(xtile, ytile)


func asinh(z):
	return log(z + sqrt(1+pow(z,2)))
