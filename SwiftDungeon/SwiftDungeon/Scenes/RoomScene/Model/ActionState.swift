import SwiftUI

/// An action snapshot to get from `RoomGameManager` to pass to ViewModel so you can animate the hit and action impact number
struct ActionState {

	var actionImpact: Int
	var isHeroTurn: Bool
	var actionColor: Color
}
