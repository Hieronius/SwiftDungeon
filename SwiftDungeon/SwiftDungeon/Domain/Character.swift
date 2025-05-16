import Foundation

class Character: Creature {

	let name: String
	var stats: Stats
	var maxHealth: Int
	var currentHealth: Int
	var maxMana: Int
	var currentMana: Int
	var maxEnergy: Int
	var currentEnergy: Int
	var spellPower: Int
	var maxDamage: Int
	var minDamage: Int
	var blockValue: Int
	var currentArmor: Int
	var isAffected: Bool
	var isStunned: Bool
	var activeEffects: [Effect]

	init(name: String,
		 stats: Stats,
		 maxHealth: Int,
		 currentHealth: Int,
		 maxMana: Int,
		 currentMana: Int,
		 maxEnergy: Int,
		 spellPower: Int,
		 currentEnergy: Int,
		 blockValue: Int,
		 currentArmor: Int,
		 maxDamage: Int,
		 minDamage: Int,
		 isAffected: Bool,
		 isStunned: Bool,
		 activeEffects: [Effect])
	{
		self.name = name
		self.stats = stats
		self.maxHealth = maxHealth
		self.currentHealth = currentHealth
		self.maxMana = maxMana
		self.currentMana = currentMana
		self.maxEnergy = maxEnergy
		self.spellPower = spellPower
		self.currentEnergy = currentEnergy
		self.maxDamage = maxDamage
		self.minDamage = minDamage
		self.blockValue = blockValue
		self.currentArmor = currentArmor
		self.isAffected = isAffected
		self.isStunned = isStunned
		self.activeEffects = activeEffects
	}

	func heroLevelUP() {

		stats.level += 1
		stats.maxExperience += 100
		stats.currentExperience = 1
		stats.strength += 2
		stats.agility += 2
		stats.vitality += 2
		stats.intellect += 1
		maxHealth += 10
		maxMana += 10
		maxDamage += 1
		minDamage += 1
//		restoreCharacter(isHeroTurn: true)


	}

	func restoreCharacter() {
		currentHealth = maxHealth
		currentMana = maxMana
		currentEnergy = maxEnergy
	}

	// func applyEffect(impact: Int) {
	// self.health += impact * 2

	// func receiveDamage

	// func restoreHeath
}
