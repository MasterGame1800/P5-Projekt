extends Node

var client : NakamaClient
var session : NakamaSession
var socket : NakamaSocket
var the_match
var current_match_id : String

signal users_updated(users)
signal count_changed(count)
signal start_game
signal updated_players_properties(players)

var current_users = {}            # session_id -> presence
var display_names = {}            # session_id -> String
var player_numbers = {}           # session_id -> int
var my_session_id
var no_count = 0


func _ready():
	client = Nakama.create_client("defaultkey", "p5-werwolf.duckdns.org", 7350, "http")


func authenticate() -> bool:
	if session == null or session.expired:
		var device_id = OS.get_unique_id()
		session = await client.authenticate_device_async(device_id)
		return session != null and !session.is_exception()
	return true


func connect_to_server() -> bool:
	if socket == null:
		socket = Nakama.create_socket_from(client)
		socket.received_match_presence.connect(_on_match_presence)
		socket.connect("received_match_state", _on_received_match_state)
	if not socket.is_connected_to_host():
		var connection = await socket.connect_async(session)
		if connection.is_exception():
			push_error("Connection failed: ", connection.get_exception().message)
			return false
	return true


func create_match() -> bool:
	if not await connect_to_server():
		return false
	the_match = await socket.create_match_async()
	if the_match.is_exception():
		push_error("Match creation failed: ", the_match.get_exception().message)
		return false
	
	current_match_id = the_match.match_id
	current_users.clear()
	display_names.clear()
	player_numbers.clear()
	
	my_session_id = the_match.self_user.session_id
	current_users[my_session_id] = the_match.self_user
	_reassign_all()
	users_updated.emit(display_names.values())
	return true


func join_match(match_id: String) -> bool:
	if await connect_to_server():
		the_match = await socket.join_match_async(match_id)
		if the_match.is_exception():
			return false
		
		current_match_id = match_id
		current_users.clear()
		display_names.clear()
		player_numbers.clear()
		
		my_session_id = the_match.self_user.session_id
		for p in the_match.presences:
			current_users[p.session_id] = p
		_reassign_all()
		users_updated.emit(display_names.values())
		return true
	return false


func find_match_id_by_code(code: String) -> String:
	var the_matches = await client.list_matches_async(session, 1, 25, 100, false, "", "")
	if the_matches.is_exception():
		print("Error listing matches: ", the_matches.get_exception().message)
		return ""
	var target_code = code.to_lower()
	for a_match in the_matches.matches:
		if a_match.match_id.to_lower().begins_with(target_code):
			return a_match.match_id
	return ""


func _reassign_all():
	player_numbers.clear()
	var idx = 1
	for p in current_users.values():
		player_numbers[p.session_id] = idx
		idx += 1
	
	var regex = RegEx.new()
	regex.compile("^Player\\d+$")
	
	for sid in player_numbers.keys():
		var name = display_names.get(sid, "")
		if name == "" or regex.search(name):
			display_names[sid] = "Player%d" % player_numbers[sid]


func _on_match_presence(event: NakamaRTAPI.MatchPresenceEvent):
	var new_users = []
	if event.match_id != current_match_id:
		return
	
	for join in event.joins:
		current_users[join.session_id] = join
	for leave in event.leaves:
		current_users.erase(leave.session_id)
		display_names.erase(leave.session_id)
	new_users.append(current_users.values()[-1])
	
	_reassign_all()
	users_updated.emit(display_names.values())
	
	if new_users.size() > 0 and not new_users[0].session_id == my_session_id:
		send_data_to_match({
			"session_id": my_session_id,
			"display_name": display_names[my_session_id]
		}, 2)


func update_display_name(new_name: String):
	if not display_names.values().has(new_name):
		display_names[my_session_id] = new_name
		send_data_to_match({"session_id": my_session_id, "display_name": new_name}, 2)
		users_updated.emit(display_names.values())


func update_players_propertys(players):
	var dickes_ding = {}
	for player in players:
		dickes_ding[player.player_name] = player
	send_data_to_match(dickes_ding, 4)


func _on_received_match_state(p_state: NakamaRTAPI.MatchData):
	var data = JSON.parse_string(p_state.data)
	if p_state.op_code == 2:
		var sid = data.get("session_id", "")
		var name = data.get("display_name", "")
		if sid != "" and name != "":
			display_names[sid] = name
			users_updated.emit(display_names.values())
	elif p_state.op_code == 3:
		start_game.emit()
	elif p_state.op_code == 4:
		updated_players_properties.emit(data.values())


func send_data_to_match(data: Dictionary, op_code: int):
	await socket.send_match_state_async(current_match_id, op_code, JSON.stringify(data))


func leave_match() -> bool:
	if current_match_id == "":
		push_error("Not in a match")
		return false
	if not await connect_to_server():
		return false
	
	var res = await socket.leave_match_async(current_match_id)
	if res.is_exception():
		push_error("Failed to leave match: ", res.get_exception().message)
		return false
	
	current_match_id = ""
	current_users.clear()
	display_names.clear()
	player_numbers.clear()
	return true


func send_count(count: String):
	send_data_to_match({"count": count}, 1)
