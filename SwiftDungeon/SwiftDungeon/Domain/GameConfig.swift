import Foundation

enum GameConfig {

	// Dungeon Config

	enum DungeonConfig {
		
		static let dungeonLength = 14
		static let expPerRoom = 50
		
	}

	// Ability Mana Cost

	static let healManaCost = 10
	static let buffManaCost = 10
	static let fireballManaCost = 15
	static let dotManaCost = 15
	static let exhaustionManaCost = 20
	static let healthRegenManaCost = 15
	static let manaRegenManaCost = 15

	// Ability Energy Cost

	static let attackEnergyCost = 1
	static let blockEnergyCost = 1
	static let stunEnergyCost = 1
	static let spellEnergyCost = 1
	static let cutEnergyCost = 1
	static let sunderArmorCost = 1

	// Ability Duration

	// 2 turns (Target -> Caster), not rounds

	static let blockDuration = 2
	static let bleedDuration = 3
	static let buffDuration = 3
	static let stunDuration = 2
	static let sunderArmorDuration = 2
	static let dotDuration = 3
	static let exhaustionDuration = 2
	static let healthRegenDuration = 3
	static let manaRegenDuration = 3
}
