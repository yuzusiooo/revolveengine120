extends Control

var Scores:Array

func update_highscoreRecord(scoreboardResult:Dictionary):
	Scores = $Scores.get_children()
	for i in Scores.size():
		Scores[i].text = String(scoreboardResult[String(i)]["score"])
