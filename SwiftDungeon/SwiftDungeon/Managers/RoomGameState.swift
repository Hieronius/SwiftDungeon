import SwiftUI

class RoomGameState {

	// Room State

	var enemyIndex = 1
	var isGameOn = true
	var isGameOver = false
	var isGameCompleted = false
	var currentRound = 0
	var currentRoom = 1

	// Characters State

	var hero: Character?
	var enemy: Character?
	var isHeroWon = false
	var isHeroTurn = true
}
