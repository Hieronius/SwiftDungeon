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
			
		case .block(let value):
			currentArmor += value
			print("armor up")
		case .healthRegen(let initialHeal, _):
			currentHealth = min(currentHealth + initialHeal, maxHealth)
		case .bleeding(let initialDamage, _):
			currentHealth -= initialDamage
			print("initil cut damage")
		}
		activeEffects.append(effect)
	}

	// 2) START OF TURN: tick & expire
	func processEffectsAtTurnStart() {
		// iterate backwards so removals don’t shift indices
		for idx in (0..<activeEffects.count).reversed() {
			var effect = activeEffects[idx]

			// ticking: apply per-turn
			if effect.type.isTicking {
				switch effect.type {
				case .healthRegen(_, let perTurn):
					currentHealth = min(currentHealth + perTurn, maxHealth)
				case .bleeding(_, let perTurn):
					currentHealth -= perTurn
				default:
					break
				}
			}

			// decrement duration
			effect.duration -= 1
			activeEffects[idx] = effect

			// expired? revert any static buff & remove
			if effect.duration <= 0 {
				if case .block(let value) = effect.type {
					currentArmor -= value
				}
				activeEffects.remove(at: idx)
			}
		}
	}

	// convenience filters
	func clearAllEffects() {
		// revert all remaining buffs first
		for effect in activeEffects {
			if case .block(let value) = effect.type {
				currentArmor -= value
			}
		}
		activeEffects.removeAll()
	}
	func clearBuffs() {
		let (buffs, rest) = activeEffects.partitioned { !$0.type.isDebuff }
		buffs.forEach {
			if case .block(let value) = $0.type {
				currentArmor -= value
			}
		}
		activeEffects = rest
	}
	func clearDebuffs() {
		let (debuffs, rest) = activeEffects.partitioned { $0.type.isDebuff }
		// no static debuffs today, but you’d revert them here
		activeEffects = rest
	}
}

// helper to split an array
extension Array {
	func partitioned(by isFirst: (Element) -> Bool) -> (first: [Element], second: [Element]) {
		var a = [Element]()
		var b = [Element]()
		for x in self {
			if isFirst(x) {
				a.append(x)
			} else {
				b.append(x)
			}
		}
		return (first: a, second: b)
	}
}
