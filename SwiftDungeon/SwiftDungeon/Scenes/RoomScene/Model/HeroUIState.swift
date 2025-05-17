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
	
}
