import SwiftUI

/// `ViewModel` of DungeonScene to connect DungeonManager business logic with UI
final class DungeonViewModel: ObservableObject {

	// MARK: - Dependencies

	/// Manager of orchestrate User movements at the map with all kinds of events
	let dungeonGameManager: DungeonGameManager

	// MARK: - Properties

	/// Tuple property to identify Hero position on the Map matrix on the Screen
	@Published var heroPosition: (row: Int, col: Int) = (0, 0)

	/// Actual Dungeon Map full of Tiles displayed by UI
	@Published var dungeonMap: [[Tile]] = []

	// MARK: - Initialization

	init(dungeonGameManager: DungeonGameManager) {
		self.dungeonGameManager = dungeonGameManager

		self.syncDungeonStateUISnapshot()
	}

	// MARK: - Methods



	// MARK: Sync UI with Current Dungeon State Snapshot

	/// Get actual state snapshot and update UI
	func syncDungeonStateUISnapshot() {

		let snapshot = dungeonGameManager.dungeonGameState.getActualGameStateSnapshot()
		self.heroPosition = snapshot.heroPosition
		self.dungeonMap = snapshot.dungeonMap
	}

	// MARK: Check If Tile IsHeroPosition

	/// Method should compare current tile and hero coordinates
	func checkIfHeroPositionTile(_ row: Int, _ col: Int) -> Bool {

		let heroPosition = dungeonGameManager.passHeroPosition()
		return heroPosition == (row, col)
	}

	// MARK: Handle Tapped Direction

	/// Should be binded to Tile button action and just call dungeon game manager to handle things
	func handleTappedDirection(_ row: Int, _ col: Int) {

		dungeonGameManager.handleTappedDirection(row, col)
		syncDungeonStateUISnapshot()
	}


}
