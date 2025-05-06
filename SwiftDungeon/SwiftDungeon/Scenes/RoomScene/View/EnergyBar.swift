import SwiftUI

// MARK: Energy Bar View

struct EnergyBar: View {
	
	var currentEnergy: Int // Value between 1 and 5
	var maxEnergy: Int

	var body: some View {
		HStack {
			ForEach(0..<maxEnergy, id: \.self) { index in
				Rectangle()
					.frame(width: 10, height: 15)
					.foregroundColor(index < currentEnergy ? .yellow : .gray) // Filled or empty
			}
		}
	}
}
