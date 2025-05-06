import Foundation

struct GameConfig {

	// Dungeon Config

	static let dungeonLength = 14
	static let expPerRoom = 50

	// Ability Mana Cost

	static let healManaCost = 10
	static let buffManaCost = 10

	// Ability Energy Cost

	static let attackEnergyCost = 1
	static let blockEnergyCost = 1
	static let stunEnergyCost = 1
	static let spellEnergyCost = 1
	static let cutEnergyCost = 1

	// Ability Duration

	static let blockDuration = 2
	static let bleedDuration = 3
	static let buffDuration = 3
	// 2 turns (Target -> Caster), not rounds
	static let stunDuration = 2
}
