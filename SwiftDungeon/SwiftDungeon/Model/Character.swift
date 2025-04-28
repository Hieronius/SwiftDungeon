import Foundation

class Character: Creature {

	let name: String
	let maxHealth: Int
	var currentHealth: Int
	let maxMana: Int
	var currentMana: Int
	let maxEnergy: Int
	var currentEnergy: Int
	var maxDamage: Int
	var minDamage: Int

	init(name: String,
		 maxHealth: Int,
		 currentHealth: Int,
		 maxMana: Int,
		 currentMana: Int,
		 maxEnergy: Int,
		 currentEnergy: Int,
		 maxDamage: Int,
		 minDamage: Int)
	{
		self.name = name
		self.maxHealth = maxHealth
		self.currentHealth = currentHealth
		self.maxMana = maxMana
		self.currentMana = currentMana
		self.maxEnergy = maxEnergy
		self.currentEnergy = currentEnergy
		self.maxDamage = maxDamage
		self.minDamage = minDamage
	}
}
