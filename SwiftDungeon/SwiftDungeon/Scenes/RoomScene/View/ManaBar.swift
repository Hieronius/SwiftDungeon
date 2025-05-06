import SwiftUI

struct ManaBar: View {

	var currentMana: CGFloat // Value between 0 and 100
	var maxMana: CGFloat

	private var manaPercentage: CGFloat {
		guard maxMana > 0 else { return 0 }
		return (currentMana / maxMana) * 75
	}

	var body: some View {
		ZStack(alignment: .leading) {
			Rectangle()
				.frame(width: 75, height: 15)
				.foregroundColor(.gray) // Background bar

			Rectangle()
				.frame(width: manaPercentage, height: 15) // Adjust width dynamically
				.foregroundColor(.blue) // Mana bar
		}
		.cornerRadius(5)
	}
}
