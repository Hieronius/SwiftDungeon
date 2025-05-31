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

	/// Game Tiles Generator
	let dungeonMapGenerator: DungeonMapGenerator

	// MARK: - Properties

	/// Should be put to DungeonManager
	var currentDungeonLevel = 1

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

	init(dungeonMapGenerator: DungeonMapGenerator) {
		self.dungeonMapGenerator = dungeonMapGenerator

		// TODO: Generate and Spawn Hero Methods runs 3 times. FIX
//		generateMap()
		let level = dungeonMapGenerator.dungeonLevel10
		dungeonMap = dungeonMapGenerator.parseDungeonLevel(level)
		spawnHero()
	}

	// MARK: - Methods



	// MARK: Sync UI with Current Dungeon State Snapshot

	/// Get actual state snapshot and update UI
	func syncDungeonStateSnapshot() {

	}


	// MARK: GenerateMap

	/// Should be put to DungeonGameManager and only being called here without passing arguments
	func generateMap() {
		dungeonMap = dungeonMapGenerator.generateMap(currentDungeonLevel)
	}

	// MARK: SpawnHero

	/// Method traverse dungeon map in reversed order and put hero at the first non empty tile
	func spawnHero() {

		// map size

		let n = dungeonMap.count
		let m = dungeonMap[0].count

		// map traversing

		for row in (0..<n).reversed() {
			for col in (0..<m).reversed() {
				let tile = dungeonMap[row][col]
				if tile.type == .room && !isHeroAppeard {
					heroPosition = (row, col)
					isHeroAppeard = true
				}
			}
		}
	}

	// MARK: Check If Tile IsHeroPosition

	/// Method should compare current tile and hero coordinates
	func checkIfHeroPositionTile(_ row: Int, _ col: Int) -> Bool {
		heroPosition == (row, col)
	}


	// MARK: Handle Tapped Direction

	/// Method to define Hero movement logic based on tapped direction if it's valid to move
	func handleTappedDirection(_ row: Int, _ col: Int) {

		/*
		 TODO:
		 1. Implement movement inside the matrix ✅
		 2. Calculate starting point based on each given map ✅
		 3. Implement UI movement on the map ✅
		 4. Hide empty tiles from the map ✅
		 5. Rewrite tile creation code as TileView
		 5. Sync the game changes with UI (put an emojie to define hero position)
		 */

		// If valid -> move hero position to a new coordinate

		if checkIfDirectionValid(row, col) {

			// mark previous tile of the hero position as explored
			dungeonMap[heroPosition.row][heroPosition.col].isExplored = true

			// move hero to the new position
			
			heroPosition = (row, col)
			print("New Hero Position is \(row), \(col)")

		} else {
			print("failed attempt to move")
		}
	}

	// MARK: Check If Direction Valid

	/// Method to check is destination tile is neighbour vertically or horizontally
	func checkIfDirectionValid(_ row: Int, _ col: Int) -> Bool {

		// If empty tile -> return false

		let tileType = dungeonMap[row][col].type

		guard tileType != .empty else { return false }

		// Movement valid only if only X or Y axis coordinate change by 1

		let isTopDirectionValid = (row - heroPosition.row == 1 && col == heroPosition.col)
		let isBotDirectionValid = (heroPosition.row - row == 1 && col == heroPosition.col)
		let isLeftDirectionValid = (col - heroPosition.col == 1 &&  row == heroPosition.row)
		let isRightDirectionValid = (heroPosition.col - col == 1 && row == heroPosition.row)

		// Check each of all four possible directions

		if (isTopDirectionValid || isBotDirectionValid) ||
			(isLeftDirectionValid || isRightDirectionValid) {

			return true

		} else {
			return false
		}
	}


}
