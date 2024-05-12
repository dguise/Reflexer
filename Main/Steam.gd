extends Node

var steamGameId = str(480)

func _ready():
	OS.set_environment("SteamAppID", steamGameId)
	OS.set_environment("SteamGameID", steamGameId)
	Steam.steamInitEx()

func _process(delta):
	Steam.run_callbacks()
