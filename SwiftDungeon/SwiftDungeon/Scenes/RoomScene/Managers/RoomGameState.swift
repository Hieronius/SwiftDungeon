import SwiftUI

//protocol IState {
//	var snapshot { get set }
//}

final class RoomGameState {

	var roomGameStateSnapshot: RoomGameStateSnapshot

	init(roomGameStateSnapshot: RoomGameStateSnapshot) {
		self.roomGameStateSnapshot = roomGameStateSnapshot
	}

	// MARK: Extract Game State Snapshot

	func getActualGameStateSnapshot() -> RoomGameStateSnapshot {
		
		return self.roomGameStateSnapshot
	}

	// MARK: Apply New Game State Snapshot

	func applyNewGameStateSnapshot(_ snapshot: RoomGameStateSnapshot) {

		self.roomGameStateSnapshot = snapshot

	}
}
