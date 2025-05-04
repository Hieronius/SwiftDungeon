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
}
