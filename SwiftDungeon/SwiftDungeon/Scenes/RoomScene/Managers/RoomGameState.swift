import SwiftUI

class RoomGameState {

	// Room State

	var enemyIndex = 0
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
	var heroWasHit = false
	var enemyWasHit = false

	// Actions

	/// Result of the spell or skill, should be 0 if stun or debuff like exhaustion
	var actionImpact = 0

	func checkIsGameOneCurrentTurnHeroAndEnemy() -> CombatPrepSnapshot? {

		guard isGameOn else { return nil }

		guard let host = isHeroTurn ? hero: enemy else { return nil }
		guard let target = isHeroTurn ? enemy: hero else { return nil }

		let snapshot = CombatPrepSnapshot(isGameOn: isGameOn,
										  isHeroTurn: isHeroTurn,
										  host: host,
										  target: target)
		return snapshot
	}
}
