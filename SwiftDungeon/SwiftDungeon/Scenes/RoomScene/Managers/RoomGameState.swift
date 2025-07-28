import SwiftUI

/// Main entity to manage Room encounter game state by passing and applying current game state snapshot
final class RoomGameState {

	// MARK: - Properties

	// TODO: Make it private
	var roomGameStateSnapshot: RoomGameStateSnapshot

	// MARK: - Initialization

	init(roomGameStateSnapshot: RoomGameStateSnapshot) {
		self.roomGameStateSnapshot = roomGameStateSnapshot
	}

	// MARK: - Methods


	
	// MARK: Extract Game State Snapshot

	func getActualGameStateSnapshot() -> RoomGameStateSnapshot {
		
		return self.roomGameStateSnapshot
	}

	// MARK: Apply New Game State Snapshot

	func applyNewGameStateSnapshot(_ snapshot: RoomGameStateSnapshot) {

		self.roomGameStateSnapshot = snapshot

	}
}
