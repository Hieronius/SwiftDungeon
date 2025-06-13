import Foundation

struct RoomGameStateSnapshot {

	// Room State

	var enemyIndex = 0
	var isGameOn = true
	var isGameOver = false
	var isGameCompleted = false
	var isEnteredNewRoom = false
	var enemyDefeatedFlag = false
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
}
