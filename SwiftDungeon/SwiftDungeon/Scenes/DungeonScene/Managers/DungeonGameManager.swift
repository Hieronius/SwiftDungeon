import Foundation

/// Main Entity to orchestrate Dungeon logic with state
final class DungeonGameManager {

	// MARK: - Dependencies

	let dungeonGameState: DungeonGameState
	let dungeonMapGenerator: DungeonMapGenerator
	let dungeonScheme: DungeonScheme

	// MARK: - Initialization

	init(
		dungeonGameState: DungeonGameState,
		dungeonMapGenerator: DungeonMapGenerator,
		dungeonScheme: DungeonScheme
	) {
		self.dungeonGameState = dungeonGameState
		self.dungeonMapGenerator = dungeonMapGenerator
		self.dungeonScheme = dungeonScheme

		generateMap()
		spawnHero()
	}

	// MARK: - Methods



	// MARK: GenerateMap

	/// Extract current DungeonSnapshot -> generate new map based on current level -> save and apply new snapshot
	func generateMap() {

		var snapshot = dungeonGameState.getActualGameStateSnapshot()
		let level = snapshot.currentDungeonlevel
		let levelScheme = dungeonScheme.dungeonLevel1
		snapshot.dungeonMap = dungeonMapGenerator.parseDungeonLevel(levelScheme)
		dungeonGameState.applyNewGameStateSnapshot(snapshot)
	}

	// MARK: SpawnHero

	/// Method should traverse dungeon map in reversed order and put hero at the first non empty tile
	func spawnHero() {

		var snapshot = dungeonGameState.getActualGameStateSnapshot()

		// map size

		let map = snapshot.dungeonMap

		let n = map.count
		let m = map[0].count

		// map traversing

		for row in (0..<n).reversed() {
			for col in (0..<m).reversed() {
				let tile = map[row][col]
				if tile.type == .room && !snapshot.isHeroAppeard {
					snapshot.heroPosition = (row, col)
					snapshot.isHeroAppeard = true
				}
			}
		}

		dungeonGameState.applyNewGameStateSnapshot(snapshot)
	}

	// MARK: Pass Hero Position

	/// Method to pass hero position to ViewModel to be used by View
	func passHeroPosition() -> (Int, Int) {

		let snapshot = dungeonGameState.getActualGameStateSnapshot()
		return snapshot.heroPosition
	}

	// MARK: Handle Tapped Direction

	/// Method to define Hero movement logic based on tapped direction if it's valid to move
	func handleTappedDirection(_ row: Int, _ col: Int) {

		// If valid -> move hero position to a new coordinate

		var snapshot = dungeonGameState.getActualGameStateSnapshot()
		let heroPosition = snapshot.heroPosition

		if checkIfDirectionValid(row, col) {

			// move hero to the new position

			snapshot.dungeonMap[heroPosition.row][heroPosition.col].isExplored = true
			snapshot.heroPosition = (row, col)

			dungeonGameState.applyNewGameStateSnapshot(snapshot)
			print("New Hero Position is \(row), \(col)")

		} else {
			print("failed attempt to move")
		}
	}

	// MARK: Check If Direction Valid

	/// Method to check is destination tile is neighbour vertically or horizontally
	func checkIfDirectionValid(_ row: Int, _ col: Int) -> Bool {

		let snapshot = dungeonGameState.getActualGameStateSnapshot()

		// If empty tile -> return false

		let tileType = snapshot.dungeonMap[row][col].type
		let heroPosition = snapshot.heroPosition

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
