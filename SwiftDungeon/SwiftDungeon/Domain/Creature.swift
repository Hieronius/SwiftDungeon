import Foundation

protocol Creature {
	
	var name: String { get }
	var stats: Stats { get set }
	var maxHealth: Int { get }
	var currentHealth: Int { get set }
	var maxMana: Int { get }
	var currentMana: Int { get set }
	var maxEnergy: Int { get }
	var currentEnergy: Int { get set }
	var maxDamage: Int { get set }
	var minDamage: Int { get set }
	var spellPower: Int { get set }
	var blockValue: Int { get set }
	var currentArmor: Int { get set }
	var isAffected: Bool { get set }
	var activeEffects: [Effect] { get set }

	func applyEffect(_ effect: Effect)
	func revertEffect(_ effect: Effect)
	func clearAllEffects()
	func clearDebuffs()
	func clearBuffs()

}
