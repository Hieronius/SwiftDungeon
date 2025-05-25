import SwiftUI

/*
 MARK: Features To Implement
 - Create DungeonManager to keep track of State, Generation and Events similar to RoomGameManager
 - DungeonState to keep track on explored part of the map
 - Keep track on current User position to display hero label and scan for surroundings

 */


/// `ViewModel` of DungeonScene
final class DungeonViewModel: ObservableObject {

	// MARK: - Dependencies

	/// Game Tiles Generator
	let dungeonMapGenerator: DungeonMapGenerator


	// MARK: - Properties

	var currentDungeonLevel = 1
	@Published var dungeonMap: [[Tile]] = []

	// MARK: - Initialization

	init(dungeonMapGenerator: DungeonMapGenerator) {
		self.dungeonMapGenerator = dungeonMapGenerator
		generateMap()
	}

	// MARK: Methods

	/// Should be put to DungeonGameManager and only being called here without passing arguments
	func generateMap() {
		dungeonMap = dungeonMapGenerator.generateMap(currentDungeonLevel)
	}
}
