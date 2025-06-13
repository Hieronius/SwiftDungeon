import Foundation

/// Snapshot with values of DungeonGameState to pass and apply by DungeonGameManager
struct DungeonGameStateSnapshot {

	var currentDungeonlevel = 1
	var dungeonMap: [[Tile]] = []
	var heroPosition: (row: Int, col: Int) = (0, 0)
	var isHeroAppeard = false
	var enemyEncounteredFlag = false
}
