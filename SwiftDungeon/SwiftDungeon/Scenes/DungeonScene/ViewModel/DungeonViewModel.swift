import SwiftUI

/*
 MARK: Features To Implement
 - TODO: Think about Hero's movements method
 - Create DungeonManager to keep track of State, Generation and Events similar to RoomGameManager
 - DungeonState to keep track on explored part of the map
 - Create DungeonUIState as Published struct to replace multiple properties in DungeonViewModel
 - Keep track on current User position to display hero label and scan for surroundings

 */


/// `ViewModel` of DungeonScene to connect DungeonManager business logic with UI
final class DungeonViewModel: ObservableObject {

	// MARK: - Dependencies

	/// Game Tiles Generator
	let dungeonMapGenerator: DungeonMapGenerator


	// MARK: - Properties

	/// Should be put to DungeonManager
	var currentDungeonLevel = 1

	/// Tuple property to identify Hero position on the Map matrix.
	///
	/// Should be put to DungeonManager
	@Published var heroPosition = (0, 0)

	/// Actual Dungeon Map full of Tiles
	///
	/// Should be put to DungeonManager and binded to UI
	@Published var dungeonMap: [[Tile]] = []

	// MARK: - Initialization

	init(dungeonMapGenerator: DungeonMapGenerator) {
		self.dungeonMapGenerator = dungeonMapGenerator
		generateMap()
	}

	// MARK: Methods



	// MARK: Sync UI with Current Dungeon State Snapshot
	/// Get actual state snapshot and update UI
	func syncDungeonStateSnapshot() {

	}


	// MARK: GenerateMap
	/// Should be put to DungeonGameManager and only being called here without passing arguments
	func generateMap() {
		dungeonMap = dungeonMapGenerator.generateMap(currentDungeonLevel)
	}


	// MARK: Move Hero
	/// Method to define Hero movement logic
	func moveHero() {

	}


}
