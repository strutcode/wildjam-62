extends Control

const LeaderboardEntry = preload('res://ui/leaderboard_entry.tscn')

@onready var spinner = $VBoxContainer/Loader/Spinner

func _enter_tree():
	%Confirmation.hide()
	%Score.text = str(Game.score)
	await get_tree().process_frame
	clearScores()
	%Loader.show()
	populateScoreboard(await getScores())
	%Loader.hide()

func clearScores():
	for child in %Scores.get_children():
		child.queue_free()

func populateScoreboard(players):
	for player in players:
		var inst = LeaderboardEntry.instantiate()
		inst.setPlayer(player)
		%Scores.add_child(inst)

func getScores():
	var req := $WebClient
	req.request('https://keepthescore.com/api/hmnyhtzjrygke/board/')
	var res = await req.request_completed
	var body: PackedByteArray = res[3]

	if body:
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		return json.data.players
	else:
		return []

func postScore(username, score):
	%NameEntry.hide()
	%Save.hide()

	var reqBody = '{ "name": "%s", "score": %d }' % [username, score]

	var req := $WebClient
	req.request('https://keepthescore.com/api/hmnyhtzjrygke/player/', ["Content-Type: application/json"], HTTPClient.METHOD_POST, reqBody)
	var res = await req.request_completed
	var body: PackedByteArray = res[3]

	if body:
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		%Confirmation.show()

func addScore():
	clearScores()
	%Loader.show()
	await postScore(%NameEntry.text, Game.score)
	populateScoreboard(await getScores())
	%Loader.hide()
