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
		self.activeEffects = activeEffects
	}

	func applyEffect(_ effect: Effect) {

		switch effect.type {
		case .buff(let buff):
			switch buff {
			case .attack(let value):
				minDamage += value
				maxDamage += value
			case .armor(let value):
				currentArmor += value
			}

		case .debuff(let debuff):
			switch debuff {
			case .bleeding(let value):
				currentHealth -= value
			case .energy(let value):
				currentEnergy -= value
			}
		}
		activeEffects.append(effect)
	}

	func revertEffect(_ effect: Effect) {

		switch effect.type {

		case .buff(let buff):
			switch buff {
			case .attack(let value):
				minDamage -= value
				maxDamage -= value
			case .armor(let value):
				currentArmor -= value
			}

			// MARK: NEED REFACTORING
		case .debuff(let debuff):
			switch debuff {
			case .bleeding(let value):
				print("reversed debuff")
			case .energy(let value):
				currentEnergy -= value
			}
		}
	}

		func clearAllEffects() {
			activeEffects.forEach { revertEffect($0) }
			activeEffects.removeAll()
		}

		func clearDebuffs() {
			activeEffects.filter { $0.isDebuff }.forEach { revertEffect($0) }
			activeEffects.removeAll { $0.isDebuff }
		}

		func clearBuffs() {
			activeEffects.filter { !$0.isDebuff }.forEach { revertEffect($0) }
			activeEffects.removeAll { !$0.isDebuff }
		}
	}


