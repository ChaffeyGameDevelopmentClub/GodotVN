extends Node2D

func _ready() -> void:
	# Set the default Steamworks information into the output section
	if Global.IS_ONLINE:
		$Output/Status/Title.set_text("Steamworks Status (Online)")
	else:
		$Output/Status/Title.set_text("Steamworks Status (Offline)")
	$Output/Status/ID.set_text("Steam ID: "+str(Global.STEAM_ID))
	$Output/Status/Username.set_text("Username: "+str(Global.STEAM_USERNAME))
	$Output/Status/Owns.set_text("Owns App: "+str(Global.IS_OWNED))
