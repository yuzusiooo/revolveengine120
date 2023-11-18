extends Node2D

var path:String = "user://scoreboard.save"

func validate_scoreboard():
	var file = File.new()
	var valid = file.file_exists(path)
	if (!valid):
		print("error validating sore")
		reset_scoreboard()
	file.close()
	return valid

func reset_scoreboard():
	var writedata = {
		0:
			{"score": 5000000},
		1:
			{"score": 3500000},
		2:
			{"score": 2000000},
		3:
			{"score": 1000000},
		4:
			{"score": 500000}
	}
	var file = File.new()
	file.open(path, File.WRITE)
	writedata = JSON.print(writedata)
	file.store_string(writedata)
	file.close()

func get_scoreboard():
	if (validate_scoreboard()):
		var file = File.new()
		file.open(path, File.READ)
		var readdata = JSON.parse(file.get_as_text())
		file.close()
		return readdata.result

func _on_GameoverManager_recieved_finalscore(newScore):
	check_newScoreEntry(newScore)

# check if newScore fits into one of the high scores
func check_newScoreEntry(newScore):
	var scoreboard = get_scoreboard()
	for i in scoreboard.size():
		if (newScore > scoreboard[String(i)]["score"]):
			# saving the scores that is going to be moved into a buffer array
			var buffer = [newScore]
			for j in range(i, scoreboard.size()):
				buffer.append(scoreboard[String(j)]["score"])
			# remove the last entry in the buffer so that the lowest out of all high scores are removed
			buffer.resize(buffer.size()-1)
			# merge the scoreboard with the buffer
			# for each element in buffer
			for k in buffer.size():
				# offset the index position by the buffer size so that the scores higher than the buffer is saved
				var startIndex = scoreboard.size() - buffer.size()
				# update the scoreboard
				scoreboard[String(startIndex + k)]["score"] = buffer[k]
			update_scoreboard(scoreboard)
			return

func update_scoreboard(writedata):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(JSON.print(writedata))
	file.close()
