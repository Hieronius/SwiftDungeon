import SwiftUI

// TODO: Add init to convert from RoomGameStateSnapshot

/// Snapshot of Hero's current stats and effects
struct HeroUIState {

	var heroCurrentLevel: Int
	var heroMaxHealth: Int
	var heroCurrentHealth: Int
	var heroMaxMana: Int
	var heroCurrentMana: Int
	var heroMaxEnergy: Int
	var heroCurrentEnergy: Int
	var heroCurrentExperience: Int
	var heroMaxExperience: Int
	var heroActionColor: Color
	var heroActionLabel: Int
	var heroBeingHit: Bool
	var heroActiveEffects: [Effect]

	init(
		heroCurrentLevel: Int,
		heroMaxHealth: Int,
		heroCurrentHealth: Int,
		heroMaxMana: Int,
		heroCurrentMana: Int,
		heroMaxEnergy: Int,
		heroCurrentEnergy: Int,
		heroCurrentExperience: Int,
		heroMaxExperience: Int,
		heroActionColor: Color,
		heroActionLabel: Int,
		heroBeingHit: Bool,
		heroActiveEffects: [Effect]
	) {
		self.heroCurrentLevel = heroCurrentLevel
		self.heroMaxHealth = heroMaxHealth
		self.heroCurrentHealth = heroCurrentHealth
		self.heroMaxMana = heroMaxMana
		self.heroCurrentMana = heroCurrentMana
		self.heroMaxEnergy = heroMaxEnergy
		self.heroCurrentEnergy = heroCurrentEnergy
		self.heroCurrentExperience = heroCurrentExperience
		self.heroMaxExperience = heroMaxExperience
		self.heroActionColor = heroActionColor
		self.heroActionLabel = heroActionLabel
		self.heroBeingHit = heroBeingHit
		self.heroActiveEffects = heroActiveEffects
	}
}

extension HeroUIState {

	init(from snapshot: RoomGameStateSnapshot) {

		guard let hero = snapshot.hero else { return }
	heroCurrentLevel = hero.stats.level
	heroMaxHealth = hero.maxHealth
		heroCurrentHealth = hero.currentHealth
		heroMaxMana = hero.maxMana
		heroCurrentMana = hero.currentMana
		heroMaxEnergy = hero.maxEnergy
		heroCurrentEnergy = hero.currentEnergy
		heroCurrentExperience = hero.stats.currentExperience
		heroMaxExperience = hero.stats.maxExperience
		heroActionColor = hero.heroUIState.heroActionColor
		heroActionLabel = snapshot.heroUIState.heroActionLabel
		heroBeingHit = snapshot.heroUIState.heroBeingHit
		heroActiveEffects = snapshot.hero.activeEffects
	}

}
