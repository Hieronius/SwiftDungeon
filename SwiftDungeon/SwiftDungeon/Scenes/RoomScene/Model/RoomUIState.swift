import Foundation

/// Visual Snapshot of RoomGameState to display
struct RoomUIState {

	var currentRoom = 1
	var currentRound = 1
	var isEnteredNewRoom = false
	var isHeroTurn = true
	var heroWasHit = false
	var enemyWasHit = false
}
