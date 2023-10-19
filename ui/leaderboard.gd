extends Control

const LeaderboardEntry = preload('res://ui/leaderboard_entry.tscn')

@onready var spinner = $VBoxContainer/Loader/Spinner

func _enter_tree():
	await get_tree().process_frame
	populateScoreboard(await getScores())

func populateScoreboard(players):
	var scores = %Scores

	for child in scores.get_children():
		child.queue_free()

	for player in players:
		var inst = LeaderboardEntry.instantiate()
		inst.setPlayer(player)
		scores.add_child(inst)

func getScores():
	%Loader.show()
	var req := $WebClient
	req.request('https://keepthescore.com/api/hmnyhtzjrygke/board/')
	var res = await req.request_completed
	var body: PackedByteArray = res[3]

	if body:
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		%Loader.hide()
		return json.data.players
	else:
		%Loader.hide()
		return []

func postScore():
	var username = "Puck"
	var score = 1000
	var reqBody = '{ "name": "%s", "score": %d }' % [username, score]

	var req := $WebClient
	req.request('https://keepthescore.com/api/hmnyhtzjrygke/player/', ["Content-Type: application/json"], HTTPClient.METHOD_POST, reqBody)
	var res = await req.request_completed
	var body: PackedByteArray = res[3]

	if body:
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
