import Foundation

/// CharacterManager - Manages spawning and resetting Characters
class CharacterManager {
	private var enemyList: [Character] = []
	
		// Prepare a list of enemies
		enemyList = [
					Enemy(name: "Skeleton", maxHealth: 15, currentHealth: 15, maxMana: 0, currentMana: 0, maxEnergy: 1, currentEnergy: 1, maxDamage: 5, minDamage: 2, skills: [], spells: []),
					Enemy(name: "Zombie", maxHealth: 17, currentHealth: 17, maxMana: 0, currentMana: 0, maxEnergy: 1, currentEnergy: 1, maxDamage: 6, minDamage: 3, skills: [], spells: []),
					Enemy(name: "Golem", maxHealth: 19, currentHealth: 19, maxMana: 0, currentMana: 0, maxEnergy: 1, currentEnergy: 1, maxDamage: 7, minDamage: 4, skills: [], spells: []),
					Enemy(name: "Witch", maxHealth: 18, currentHealth: 18, maxMana: 10, currentMana: 10, maxEnergy: 2, currentEnergy: 2, maxDamage: 6, minDamage: 3, skills: [], spells: []),
					Enemy(name: "Vampire", maxHealth: 20, currentHealth: 20, maxMana: 0, currentMana: 0, maxEnergy: 2, currentEnergy: 2, maxDamage: 7, minDamage: 4, skills: [], spells: []),
					Enemy(name: "Mummy", maxHealth: 22, currentHealth: 22, maxMana: 0, currentMana: 0, maxEnergy: 2, currentEnergy: 2, maxDamage: 8, minDamage: 5, skills: [], spells: []),
					Enemy(name: "Giant Spider", maxHealth: 21, currentHealth: 21, maxMana: 0, currentMana: 0, maxEnergy: 2, currentEnergy: 2, maxDamage: 8, minDamage: 4, skills: [], spells: []),
					Enemy(name: "Werewolf", maxHealth: 23, currentHealth: 23, maxMana: 0, currentMana: 0, maxEnergy: 2, currentEnergy: 2, maxDamage: 9, minDamage: 5, skills: [], spells: []),
					Enemy(name: "Goblin", maxHealth: 16, currentHealth: 16, maxMana: 0, currentMana: 0, maxEnergy: 1, currentEnergy: 1, maxDamage: 5, minDamage: 2, skills: [], spells: []),
					Enemy(name: "Ogre", maxHealth: 25, currentHealth: 25, maxMana: 0, currentMana: 0, maxEnergy: 3, currentEnergy: 3, maxDamage: 10, minDamage: 6, skills: [], spells: []),
					Enemy(name: "Troll", maxHealth: 28, currentHealth: 28, maxMana: 0, currentMana: 0, maxEnergy: 3, currentEnergy: 3, maxDamage: 12, minDamage: 7, skills: [], spells: []),
					Enemy(name: "Dark Knight", maxHealth: 30, currentHealth: 30, maxMana: 0, currentMana: 0, maxEnergy: 3, currentEnergy: 3, maxDamage: 13, minDamage: 8, skills: [], spells: []),
					Enemy(name: "Dragon", maxHealth: 35, currentHealth: 35, maxMana: 0, currentMana: 0, maxEnergy: 4, currentEnergy: 4, maxDamage: 15, minDamage: 10, skills: [], spells: []),
					Enemy(name: "Demon", maxHealth: 32, currentHealth: 32, maxMana: 0, currentMana: 0, maxEnergy: 3, currentEnergy: 3, maxDamage: 14, minDamage: 9, skills: [], spells: []),
					Enemy(name: "Griffin", maxHealth: 28, currentHealth: 28, maxMana: 0, currentMana: 0, maxEnergy: 3, currentEnergy: 3, maxDamage: 12, minDamage: 7, skills: [], spells: [])
				]
	}

	func setupHero() -> Character {
		return Character(name: "Hieronius",
						  maxHealth: 100,
						  currentHealth: 100,
						  maxMana: 50,
						  currentMana: 50,
						  maxEnergy: 3,
						  currentEnergy: 3,
						  maxDamage: 10,
						  minDamage: 5,
						  skills: [],
						  spells: [])
	}

	func spawnEnemy() -> Character? {
		guard !enemyList.isEmpty else { return nil }
		return enemyList.removeFirst()
	}

//	func resetCharacters() {
//		scene.hero.currentHealth = scene.hero.maxHealth
//		scene.hero.currentMana = scene.hero.maxMana
//		scene.hero.currentEnergy = scene.hero.maxEnergy
//		scene.enemy.currentHealth = scene.enemy.maxHealth
//		scene.enemy.currentMana = scene.enemy.maxMana
//		scene.enemy.currentEnergy = scene.enemy.maxEnergy
//	}
}
