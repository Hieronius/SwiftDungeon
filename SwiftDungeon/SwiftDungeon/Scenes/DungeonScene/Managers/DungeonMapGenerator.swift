import Foundation

/*
 MARK: - Plan to implement Tiles
 1. Implement 10 different sets of predefines maps and just use random or level specific property to load the level accordingly without any random generation code
 - How about a defined set of empty/corridors/rooms which should be affected by current level?
 - May be we also should construct the whole map in size or even an emoty ones and only after to decide how to fill it?
 */

// MARK: - DungeonMapGenerator

/// An entity to generate a unique set of tiles for each dungeon level
struct DungeonMapGenerator {

	// MARK: - Properties


	// TODO: Can be put to DungeonScheme struct and become injected to DungeonMaster

	/// 1 level - 3 x 3 == 9 tiles
	var dungeonLevel1: [[String]] = [

		["R", "C", "R"],
		["C", "E", "C"],
		["R", "E", "R"]

	]

	/// 2 level - 4 x 3 = 12 tiles
	var dungeonlevel2: [[String]] = [

		["R", "R", "R"],
		["C", "E", "C"],
		["C", "C", "C"],
		["E", "R", "E"]

	]

	/// 3 level - 4 x 4 = 16 tiles
	var dungeonLevel3: [[String]] = [

		["E", "E", "E", "E"],
		["E", "E", "E", "E"],
		["E", "E", "E", "E"],
		["E", "E", "E", "E"]
	]


	/// 4 level - 4 x 5 = 20 tiles
	var dungeonlevel4: [[String]] = [

		["E", "E", "E", "E"],
		["E", "E", "E", "E"],
		["E", "E", "E", "E"],
		["E", "E", "E", "E"],
		["E", "E", "E", "E"]

	]

	/// 5 level - 5 x 5 = 25 tiles
	var dungeonLevel5: [[String]] = [

		["E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E"],

	]

	/// 6 level - 6 x 5 = 30 tiles
	var dungeonLevel6: [[String]] = [


		["E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E"],

	]


	/// 7 level - 6 x 6 = 36 tiles
	var dungeonLevel7: [[String]] = [

		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"]

	]


	/// 8 level - 6 x 6 = 36 tiles
	var dungeonLevel8: [[String]] = [

		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"]

	]


	/// 9 level - 6 x 6 = 36 tiles
	var dungeonLevel9: [[String]] = [

		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"]

	]


	/// 10 level - 6 x 6 = 36 tiles
	var dungeonLevel10: [[String]] = [

		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"]

	]









	// MARK: - Methods



	// MARK: ParseDungeonLevel

	/// Method to get a predefined level scheme and convert into real dungeon level
	func parseDungeonLevel(_ levelScheme: [[String]]) -> [[Tile]] {

		let rows = levelScheme.count
		let cols = levelScheme[0].count

		let defaultTile = Tile(
			row: 0,
			col: 0,
			type: .empty,
			isExplored: false,
			events: []
		)

		var level: [[Tile]] = Array(repeating: Array(repeating: defaultTile,
													 count: cols),
								 count: rows)

		for row in 0..<rows {
			print(row)

			for col in 0..<cols {

				let tileType = levelScheme[row][col]
				level[row][col] = generateTile(row, col, tileType)
			}
		}

		return level
	}

	// MARK: GenerateTile

	/// Method to get an exact coordinates and tile type to generate a complete Tile
	func generateTile(_ row: Int, _ col: Int, _ type: String) -> Tile {

		switch type {

		case "R": return Tile(
			row: row,
			col: col,
			type: .room,
			isExplored: false,
			events: []
		)

		case "C": return Tile(
			row: row,
			col: col,
			type: .corridor,
			isExplored: false,
			events: []
		)

		case "E": return Tile(
			row: row,
			col: col,
			type: .empty,
			isExplored: false,
			events: []
		)

		default: return Tile(
			row: row,
			col: col,
			type: .empty,
			isExplored: false,
			events: []
		)

		}
	}

	// MARK: GenerateMap

	// Method should apply current level of the dungeon to generate set of tiles
	func generateMap(_ currentLevel: Int) -> [[Tile]] {

		// Generate level size based on currentLevel

		let ratio = currentLevel
		let rowsSize = Int.random(in: 1+ratio...5+ratio)
		let columnsSize = Int.random(in: 1+ratio...5+ratio)

		// Define overall tiles pool and for empty/corridor/room to keep track of while filling dungeon with objects

		let mapSize = rowsSize * columnsSize // for 10*10 = 100
		var roomsPool = Int(Double(mapSize) * 0.15) // 15 % of the possible tiles
		var corridorsPool = Int(Double(mapSize) * 0.35) // 35 % of the possible tiles

		// 1. Populate matrix with empty tiles
		// In other words it's just am empty rectangle of all possible space filled with empty rooms to work with

		let defaultTile = Tile(
			row: 0,
			col: 0,
			type: .empty,
			isExplored: false,
			events: []
		)

		var map: [[Tile]] = Array(repeating: Array(repeating: defaultTile,
												   count: rowsSize),
								  count: columnsSize)

		// 2. Traverse matrix again and generate a unique tile for each element of the matrix

		for row in 0..<map.count {

			for col in 0..<map[row].count {

				// Generate Random Tile

				let tile = generateRandomTile(row, col)
				map[row][col] = tile
			}
		}

		// 3-4-5 traverse matrix and each time add a new feature

		return map
	}



	// MARK: GenerateRandomTile

	/// Method to generate a random tile like .empty/.room/.corridor
	func generateRandomTile(_ row: Int, _ col: Int) -> Tile {

		/*
		 MARK: Current Ratio of the elements on the map:
		 - `Empty` around 33 %
		 - `Rooms` around 33 %
		 - `Corridors` around 33 %
		 */

		let random = Int.random(in: 1...3)

		switch random {

		// Put Room Tile on the map
			
		case 1: return Tile(row: row,
						col: col,
						type: .room,
						isExplored: false,
						events: [])

		// Put Corridor Tile on the map

		case 2: return Tile(row: row,
						col: col,
						type: .corridor,
						isExplored: false,
						events: [])

		// Put Empty Tile on the map

		case 3: return Tile(row: row,
						col: col,
						type: .empty,
						isExplored: false,
						events: [])

		// Put Empty Tile on the map at any other conditions

		default: return Tile(row: row,
						col: col,
						type: .empty,
						isExplored: false,
						events: [])
		}
	}
}
