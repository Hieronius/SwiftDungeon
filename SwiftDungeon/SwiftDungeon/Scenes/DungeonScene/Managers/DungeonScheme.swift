import Foundation

/// Set of hardcoded DungeonLevel schemes to be parsed by DungeonMapGenerator
struct DungeonScheme {

	// MARK: - Properties

	/// 1 level - 3 x 3 == 9 tiles
	let dungeonLevel1: [[String]] = [

		["R", "C", "R"],
		["C", "E", "C"],
		["R", "E", "R"]

	]

	/// 2 level - 4 x 3 = 12 tiles
	let dungeonLevel2: [[String]] = [

		["R", "R", "R"],
		["C", "E", "C"],
		["C", "C", "C"],
		["E", "R", "E"]

	]

	/// 3 level - 4 x 4 = 16 tiles
	let dungeonLevel3: [[String]] = [

		["R", "C", "R", "C"],
		["C", "E", "E", "R"],
		["C", "C", "E", "C"],
		["E", "R", "E", "R"]
	]

	/// 4 level - 4 x 5 = 20 tiles
	let dungeonLevel4: [[String]] = [

		["R", "C", "E", "E"],
		["E", "R", "C", "R"],
		["E", "E", "E", "C"],
		["C", "C", "C", "R"],
		["R", "E", "E", "E"]

	]

	/// 5 level - 5 x 5 = 25 tiles
	let dungeonLevel5: [[String]] = [

		["E", "E", "E", "E", "E"],
		["R", "C", "C", "C", "E"],
		["C", "E", "E", "R", "C"],
		["R", "C", "C", "E", "R"],
		["E", "E", "R", "E", "E"],

	]

	/// 6 level - 6 x 5 = 30 tiles
	let dungeonLevel6: [[String]] = [

		["E", "E", "R", "C", "R"],
		["E", "E", "C", "E", "C"],
		["E", "R", "C", "E", "C"],
		["E", "C", "E", "R", "C"],
		["R", "C", "E", "C", "E"],
		["E", "E", "E", "C", "R"],

	]

	/// 7 level - 6 x 6 = 36 tiles
	let dungeonLevel7: [[String]] = [

		["E", "R", "C", "C", "E", "R"],
		["E", "C", "E", "R", "E", "C"],
		["R", "C", "E", "C", "C", "R"],
		["C", "E", "E", "E", "E", "E"],
		["C", "E", "R", "C", "C", "E"],
		["R", "C", "C", "E", "R", "E"]

	]

	/// 8 level - 6 x 6 = 36 tiles
	let dungeonLevel8: [[String]] = [

		["R", "C", "C", "C", "C", "R"],
		["C", "E", "E", "E", "E", "C"],
		["C", "R", "E", "E", "C", "R"],
		["E", "C", "E", "R", "C", "E"],
		["R", "C", "E", "E", "E", "E"],
		["E", "E", "E", "E", "E", "E"]

	]

	/// 9 level - 6 x 7 = 42 tiles
	let dungeonLevel9: [[String]] = [

		["R", "C", "C", "E", "C", "R"],
		["C", "E", "C", "E", "C", "E"],
		["C", "E", "C", "E", "C", "E"],
		["C", "E", "C", "C", "C", "E"],
		["C", "E", "E", "E", "E", "E"],
		["C", "C", "C", "C", "C", "R"]

	]

	/// 10 level - 6 x 6 = 36 tiles
	let dungeonLevel10: [[String]] = [

		["E", "R", "R", "C", "E", "E"],
		["R", "C", "E", "C", "C", "R"],
		["E", "E", "E", "E", "E", "C"],
		["C", "R", "C", "C", "E", "C"],
		["C", "E", "E", "C", "C", "R"],
		["R", "C", "C", "E", "E", "E"],
		["E", "E", "R", "E", "E", "E"]

	]
}
