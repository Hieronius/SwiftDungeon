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

		// Buffs

		case .blockUP(let value):
			currentArmor += value
			print("armor up")
		case .attackUP(value: let value):
			minDamage += value
			maxDamage += value
		case .healthRegen(let initialHeal, _):
			currentHealth = min(currentHealth + initialHeal, maxHealth)
		case .manaRegen(initialMana: let initialMana, _):
			currentMana = min(currentMana + initialMana, maxMana)

		// Debuffs
		case .bleeding(let initialDamage, _):
			currentHealth -= initialDamage
			print("initil cut damage")
		case .blockDOWN(value: let value):
			currentArmor -= value
		case .exaustion(initialEnergy: let initialEnergy, _):
			currentEnergy = max(currentEnergy - initialEnergy, 0)
		case .attackDOWN(value: let value):
			minDamage -= value
			maxDamage -= value
		}
		activeEffects.append(effect)
	}

	// 2) START OF TURN: tick & expire
	func processEffectsAtTurnStart() {
		// iterate backwards so removals don’t shift indices
		for idx in (0..<activeEffects.count).reversed() {
			var effect = activeEffects[idx]

			// TICKING: apply per-turn

			if effect.type.isTicking {
				switch effect.type {

				// Buffs

				case .healthRegen(_, let perTurn):
					currentHealth = min(currentHealth + perTurn, maxHealth)

				// Debuffs

				case .bleeding(_, let perTurn):
					currentHealth = max(currentHealth - perTurn, 0)
				case .exaustion(_, let perTurn):
					currentEnergy = max(currentEnergy - perTurn, 0)
				default:
					break
				}
			}

			// decrement duration
			effect.duration -= 1
			activeEffects[idx] = effect

			// STATIC expired? revert any static buff & remove
			if effect.duration <= 0 {

				if case .blockUP(let value) = effect.type {
					currentArmor -= value
				}

				if case .blockDOWN(let value) = effect.type {
					currentArmor += value
				}

				if case .attackUP(let value) = effect.type {
					minDamage -= value
					maxDamage -= value
				}

				if case .attackDOWN(let value) = effect.type {
					minDamage += value
					maxDamage += value
				}
				
				activeEffects.remove(at: idx)
			}
		}
	}

	// convenience filters
	func clearAllEffects() {
		// revert all remaining buffs first
		for effect in activeEffects {
			if case .blockUP(let value) = effect.type {
				currentArmor -= value
			}
		}
		activeEffects.removeAll()
	}
	func clearBuffs() {
		let (buffs, rest) = activeEffects.partitioned { !$0.type.isDebuff }
		buffs.forEach {
			if case .blockUP(let value) = $0.type {
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
