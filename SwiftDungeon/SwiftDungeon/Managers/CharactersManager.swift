import Foundation

/// CharacterManager - Manages spawning and resetting Characters
class CharacterManager {
	
	private var enemyList: [Character] = [
		Character(name: "Skeleton", maxHealth: 15, currentHealth: 15, maxMana: 0, currentMana: 0, maxEnergy: 1, spellPower: 0, currentEnergy: 1, blockValue: 1, currentArmor: 0, maxDamage: 5, minDamage: 2),
		Character(name: "Zombie", maxHealth: 17, currentHealth: 17, maxMana: 0, currentMana: 0, maxEnergy: 1, spellPower: 0, currentEnergy: 1, blockValue: 1, currentArmor: 0, maxDamage: 6, minDamage: 3),
		Character(name: "Golem", maxHealth: 19, currentHealth: 19, maxMana: 0, currentMana: 0, maxEnergy: 1, spellPower: 0, currentEnergy: 1, blockValue: 2, currentArmor: 0, maxDamage: 7, minDamage: 4),
		Character(name: "Witch", maxHealth: 18, currentHealth: 18, maxMana: 10, currentMana: 10, maxEnergy: 2, spellPower: 6, currentEnergy: 2, blockValue: 1, currentArmor: 0, maxDamage: 6, minDamage: 3),
		Character(name: "Vampire", maxHealth: 20, currentHealth: 20, maxMana: 0, currentMana: 0, maxEnergy: 2, spellPower: 2, currentEnergy: 2, blockValue: 2, currentArmor: 0, maxDamage: 7, minDamage: 4),
		Character(name: "Mummy", maxHealth: 22, currentHealth: 22, maxMana: 0, currentMana: 0, maxEnergy: 2, spellPower: 0, currentEnergy: 2, blockValue: 2, currentArmor: 0, maxDamage: 8, minDamage: 5),
		Character(name: "Giant Spider", maxHealth: 21, currentHealth: 21, maxMana: 0, currentMana: 0, maxEnergy: 2, spellPower: 0, currentEnergy: 2, blockValue: 2, currentArmor: 0, maxDamage: 8, minDamage: 4),
		Character(name: "Werewolf", maxHealth: 23, currentHealth: 23, maxMana: 0, currentMana: 0, maxEnergy: 2, spellPower: 0, currentEnergy: 2, blockValue: 2, currentArmor: 0, maxDamage: 9, minDamage: 5),
		Character(name: "Goblin", maxHealth: 16, currentHealth: 16, maxMana: 0, currentMana: 0, maxEnergy: 1, spellPower: 0, currentEnergy: 1, blockValue: 1, currentArmor: 0, maxDamage: 5, minDamage: 2),
		Character(name: "Ogre", maxHealth: 25, currentHealth: 25, maxMana: 0, currentMana: 0, maxEnergy: 3, spellPower: 0, currentEnergy: 3, blockValue: 3, currentArmor: 0, maxDamage: 10, minDamage: 6),
		Character(name: "Troll", maxHealth: 28, currentHealth: 28, maxMana: 0, currentMana: 0, maxEnergy: 3, spellPower: 0, currentEnergy: 3, blockValue: 3, currentArmor: 0, maxDamage: 12, minDamage: 7),
		Character(name: "Dark Knight", maxHealth: 30, currentHealth: 30, maxMana: 0, currentMana: 0, maxEnergy: 3, spellPower: 0, currentEnergy: 3, blockValue: 3, currentArmor: 0, maxDamage: 13, minDamage: 8),
		Character(name: "Dragon", maxHealth: 35, currentHealth: 35, maxMana: 0, currentMana: 0, maxEnergy: 4, spellPower: 10, currentEnergy: 4, blockValue: 4, currentArmor: 0, maxDamage: 15, minDamage: 10),
		Character(name: "Demon", maxHealth: 32, currentHealth: 32, maxMana: 0, currentMana: 0, maxEnergy: 3, spellPower: 8, currentEnergy: 3, blockValue: 3, currentArmor: 0, maxDamage: 14, minDamage: 9),
		Character(name: "Griffin", maxHealth: 28, currentHealth: 28, maxMana: 0, currentMana: 0, maxEnergy: 3, spellPower: 0, currentEnergy: 3, blockValue: 3, currentArmor: 0, maxDamage: 12, minDamage: 7)
	]


	func setupHero() -> Character {
		return Character(name: "Hieronius",
						  maxHealth: 100,
						  currentHealth: 100,
						  maxMana: 50,
						  currentMana: 50,
						  maxEnergy: 3,
						 spellPower: 20,
						 currentEnergy: 3,
						 blockValue: 5,
						 currentArmor: 1,
						  maxDamage: 10,
						  minDamage: 5)
	}

	func spawnEnemy(at index: Int) -> Character {
		return enemyList[index]
	}

}

