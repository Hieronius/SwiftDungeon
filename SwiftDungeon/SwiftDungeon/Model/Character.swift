import Foundation

class Character: Creature {

	let name: String
	let maxHealth: Int
	var currentHealth: Int
	let maxMana: Int
	var currentMana: Int
	let maxEnergy: Int
	var currentEnergy: Int
	var spellPower: Int
	var maxDamage: Int
	var minDamage: Int
	var blockValue: Int
	var currentArmor: Int
	var isBuffed: Bool
	var activeBuffs: [Buff]

	init(name: String,
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
		 isBuffed: Bool,
		 activeBuffs: [Buff])
	{
		self.name = name
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
		self.isBuffed = isBuffed
		self.activeBuffs = activeBuffs
	}

	func addBuff(_ buff: Buff) {
		activeBuffs.append(buff)
			   applyBuff(buff)
	}

	func applyBuff(_ buff: Buff) {
			switch buff.type {
			case .attack(let value):
				minDamage += value
				maxDamage += value
			case .armor(let value):
				currentArmor += value
			}
		}

	func revertBuff(_ buff: Buff) {
			switch buff.type {
			case .attack(let value):
				minDamage -= value
				maxDamage -= value
			case .armor(let value):
				currentArmor -= value
			}
		}
	}
