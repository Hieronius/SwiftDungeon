import Foundation

/// Main Entity to handle Dungeon State
class DungeonGameState {

	// MARK: - Properties

	/// Current Dungeon State Snapshot of the Dungeon which contains current level, explored part of the map and hero position
	private var dungeonGameStateSnapshot: DungeonGameStateSnapshot

	// MARK: - Initialization

	init(dungeonGameStateSnapshot: DungeonGameStateSnapshot) {
		self.dungeonGameStateSnapshot = dungeonGameStateSnapshot
	}

	// MARK: - Methods



	// MARK: Extract Game State Snapshot

	/// Extract current Dungeon Game State without any dunger of mutation
	func getActualGameStateSnapshot() -> DungeonGameStateSnapshot {

		return self.dungeonGameStateSnapshot
	}

	// MARK: Apply New Game State Snapshot

	/// Replace the old state snapshot with the new one in one go
	func applyNewGameStateSnapshot(_ snapshot: DungeonGameStateSnapshot) {

		self.dungeonGameStateSnapshot = snapshot

	}
}
