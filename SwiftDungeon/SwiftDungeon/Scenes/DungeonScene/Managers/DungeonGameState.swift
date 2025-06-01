import Foundation

/// Main Entity to handle Dungeon State
class DungeonGameState {

	// MARK: - Properties

	private var dungeonGameStateSnapshot: DungeonGameStateSnapshot

	// MARK: - Initialization

	init(dungeonGameStateSnapshot: DungeonGameStateSnapshot) {
		self.dungeonGameStateSnapshot = dungeonGameStateSnapshot
	}

	// MARK: - Methods



	// MARK: Extract Game State Snapshot

	func getActualGameStateSnapshot() -> DungeonGameStateSnapshot {

		return self.dungeonGameStateSnapshot
	}

	// MARK: Apply New Game State Snapshot

	func applyNewGameStateSnapshot(_ snapshot: DungeonGameStateSnapshot) {

		self.dungeonGameStateSnapshot = snapshot

	}
}
