class_name StatsData extends Resource
## All stats data.

#region VARIABLES
## How many times has the game been booted?
@export var game_booted_count: int = 0
## How many times has a new game been started?
@export var games_count: int = 0
## The score of the current or most recent game.
@export var score: int = 0:
	set(s):
		if s < 0 or s == score:
			return
		score = s
		score_changed.emit(score)
		if score > highscore:
			highscore = score
			new_highscore.emit(highscore)
## The best score.
@export var highscore: int = 0

signal score_changed(score: int)
signal new_highscore(highscore: int)
#endregion
