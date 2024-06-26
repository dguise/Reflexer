extends Node2D

var lobby_id = 0
var peer = SteamMultiplayerPeer.new()

@onready var ms = $MultiplayerSpawner

func _ready():
	ms.spawn_function = spawn_level
	peer.lobby_created.connect(_on_lobby_created)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	open_lobby_list()
	
func spawn_level(data):
	var level = (load(data) as PackedScene).instantiate()
	return level
	
func _on_host_pressed():
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer
	ms.spawn("res://level.tscn")
	$Host.hide()
	$Refresh.hide()
	$ScrollContainer/VBoxContainer.hide()

func join_lobby(id):
	peer.connect_lobby(id)
	multiplayer.multiplayer_peer = peer
	lobby_id = id
	print(str(id) + " joined")
	$Host.hide()
	$Refresh.hide()
	$ScrollContainer/VBoxContainer.hide()
	
func _on_lobby_created(connect, id):
	if connect:
		lobby_id = id
		Steam.setLobbyData(lobby_id, "name", str(Steam.getPersonaName() + "'s gamer lobby"))
		Steam.setLobbyJoinable(lobby_id, true)
		print(lobby_id)

func open_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()
	
func _on_lobby_match_list(lobbies):
	for lobby in lobbies:
		var lobby_name = Steam.getLobbyData(lobby, "name")
		if !lobby_name.ends_with("gamer lobby"):
			continue
			
		var members = Steam.getNumLobbyMembers(lobby)
		
		var btn = Button.new()
		btn.set_text(str(lobby_name + " | " + str(members) ))
		btn.set_size(Vector2(100, 5))
		btn.connect("pressed", Callable(self, "join_lobby").bind(lobby))
		
		$ScrollContainer/VBoxContainer.add_child(btn)


func _on_refresh_pressed():
	open_lobby_list()
	var explosion = preload("res://Explosion.tscn").instantiate() as GPUParticles2D
	$Refresh.add_child(explosion)
	explosion.global_position = get_global_mouse_position()
	explosion.restart()
	
