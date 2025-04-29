import Foundation

class CombatManager {

	func attack(_ host: Character, _ target: Character) {

		let damage = (host.maxDamage + host.minDamage) / 2
		target.currentHealth -= damage
	}

	func block(_ host: Character) {

	}

	// should be refactored so the method only calculates heal instead of using game state properties
	func heal(_ host: Character) {
		host.currentHealth = host.maxHealth
	}

}
