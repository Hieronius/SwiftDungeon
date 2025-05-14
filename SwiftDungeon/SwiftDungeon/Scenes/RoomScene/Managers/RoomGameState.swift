import SwiftUI

/// Expand GameStateSnapshot into fully embed in properties Struct CombatPrepSnapshot
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

	// MARK: Extract Game State Snapshot

	func getActualGameStateSnapshot() -> GameStateSnapshot {

		// Room State

		let snapshot = GameStateSnapshot(
			enemyIndex: self.enemyIndex,
			isGameOn: self.isGameOn,
			isGameOver: self.isGameOver,
			isGameCompleted: self.isGameCompleted,
			currentRound: self.currentRound,
			currentRoom: self.currentRoom,

		// Characters State

			hero: self.hero,
			enemy: self.enemy,
			isHeroWon: self.isHeroWon,
			isHeroTurn: self.isHeroTurn,
			heroWasHit: self.heroWasHit,
			enemyWasHit: self.enemyWasHit,

		// Actions

		/// Result of the spell or skill, should be 0 if stun or debuff like exhaustion
			actionImpact: self.actionImpact
			)

		return snapshot
	}

	// MARK: Apply New Game State Snapshot

	func applyNewGameStateSnapshot(_ snapshot: GameStateSnapshot) {

		// Room State


		self.enemyIndex = snapshot.enemyIndex
		self.isGameOn = snapshot.isGameOn
		self.isGameOver = snapshot.isGameOver
		self.isGameCompleted = snapshot.isGameCompleted
		self.currentRound = snapshot.currentRound
		self.currentRoom = snapshot.currentRoom

		// Characters State

		self.hero = snapshot.hero
		self.enemy = snapshot.enemy
		self.isHeroWon = snapshot.isHeroWon
		self.isHeroTurn = snapshot.isHeroTurn
		self.heroWasHit = snapshot.heroWasHit
		self.enemyWasHit = snapshot.enemyWasHit

		// Actions

		/// Result of the spell or skill, should be 0 if stun or debuff like exhaustion
		self.actionImpact = snapshot.actionImpact

	}

	/// Return a snapshot of the game state before specific action will be executed
	func checkIsGameOneCurrentTurnHeroAndEnemy() -> CombatPrepSnapshot? {

		guard isGameOn else { return nil }

		guard let host = isHeroTurn ? hero: enemy else { return nil }
		guard let target = isHeroTurn ? enemy: hero else { return nil }

		let snapshot = CombatPrepSnapshot(
			isGameOn: isGameOn,
			isHeroTurn: isHeroTurn,
			host: host,
			target: target
		)
		return snapshot
	}
}
