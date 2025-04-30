import SwiftUI

class GameState {

	var hero: Character?
	var enemy: Character?
	var enemyIndex = 1
	var isGameOn = true
	var isGameOver = false
	var isHeroWon = false
	var isHeroTurn = true
	var currentRound = 0
	var currentRoom = 1
}
