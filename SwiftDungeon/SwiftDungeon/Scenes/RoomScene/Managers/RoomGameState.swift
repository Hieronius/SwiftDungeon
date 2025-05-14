import SwiftUI

/// Expand GameStateSnapshot into fully embed in properties Struct CombatPrepSnapshot
class RoomGameState {

	var roomGameStateSnapshot: RoomGameStateSnapshot

	init(roomGameStateSnapshot: RoomGameStateSnapshot) {
		self.roomGameStateSnapshot = roomGameStateSnapshot
	}

	// MARK: Extract Game State Snapshot


	// MARK: ERROR HERE. SOMETHING WRONG WITH SYNC
	func getActualGameStateSnapshot() -> RoomGameStateSnapshot {
		return self.roomGameStateSnapshot
	}

	// MARK: Apply New Game State Snapshot

	func applyNewGameStateSnapshot(_ snapshot: RoomGameStateSnapshot) {

		self.roomGameStateSnapshot = snapshot

	}
}
