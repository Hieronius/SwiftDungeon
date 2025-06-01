import SwiftUI

/*
 MARK: Features To Implement
 - Create DungeonManager to keep track of State, Generation and Events similar to RoomGameManager
 - DungeonState to keep track on explored part of the map
 - Create DungeonUIState as Published struct to replace multiple properties in DungeonViewModel
 - Keep track on current User position to display hero label and scan for surroundings

 */


/// `ViewModel` of DungeonScene to connect DungeonManager business logic with UI
final class DungeonViewModel: ObservableObject {

	// MARK: - Dependencies

	/// Manager of orchestrate User movements at the map with all kinds of events
	let dungeonGameManager: DungeonGameManager

	// MARK: - Properties

	/// We use this property to spawn our hero in non empty Tile and set it to true to avoid respawn
	@Published var isHeroAppeard = false

	/// Tuple property to identify Hero position on the Map matrix.
	///
	/// Should be put to DungeonManager
	@Published var heroPosition = (row: 0, col: 0)

	/// Actual Dungeon Map full of Tiles
	///
	/// Should be put to DungeonManager and binded to UI
	@Published var dungeonMap: [[Tile]] = []

	// MARK: - Initialization

	init(dungeonGameManager: DungeonGameManager) {
		self.dungeonGameManager = dungeonGameManager

		self.syncDungeonStateSnapshot()
	}

	// MARK: - Methods



	// MARK: Sync UI with Current Dungeon State Snapshot

	/// Get actual state snapshot and update UI
	func syncDungeonStateSnapshot() {

		let snapshot = dungeonGameManager.dungeonGameState.getActualGameStateSnapshot()
		self.heroPosition = snapshot.heroPosition
		self.dungeonMap = snapshot.dungeonMap
		self.isHeroAppeard = snapshot.isHeroAppeard

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
		syncDungeonStateSnapshot()
	}


}
