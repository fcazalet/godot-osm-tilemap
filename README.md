# Godot OpenStreetMap TileMap

Main class OsmTileMap is the modified TileMap.
It use X HTTPRequest to request X tiles from OpenStreetMap


OpenStreetMap tiles are available at URL like https://a.tile.openstreetmap.org/5/13/8.png


More details on OpenStreetMap Wiki: https://wiki.openstreetmap.org/wiki/Main_Page
About OpenStreetMap Tiles Wiki page : https://wiki.openstreetmap.org/wiki/Tiles


## Changing latitude/longitude and zoom

You can use properties from the tilemap directly in Inspector.
Zoom is from 0 to 19.
It will reload the map area in editor.


Base Url property is for changing tiles styles. See below.


Tile Material is property to set a shader on all tiles.
SampleShaderMaterial.tres is a sample.


## Using differents map styles

Source: https://wiki.openstreetmap.org/wiki/Tiles


You can use different map style from the wiki.


Example: Change the "Base Url" from https://a.tile.openstreetmap.org to http://a.tile.stamen.com/toner


## Samples Coordinates

 - New York : 40.7893, -73.9619
 - Mediterranean 40.5335, 4.8412
 - France : 46.7294, 2.5626


## Computing X/Y from Longitude/Latitude

Source: https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames

To compute tiles coordinate on OpenStreetMap, we need to use some maths:

		n = 2 ^ zoom
		xtile = n * ((lon_deg + 180) / 360)
		ytile = n * (1 - (log(tan(lat_rad) + sec(lat_rad)) / π)) / 2