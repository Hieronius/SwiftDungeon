import SwiftUI

struct HealthBar: View {

	var currentHealth: CGFloat // Value between 0 and 100
	var maxHealth: CGFloat

	private var healthPercentage: CGFloat {
		guard maxHealth > 0 else { return 0 }
		return (currentHealth / maxHealth) * 75
	}

	var body: some View {
		ZStack(alignment: .leading) {
			Rectangle()
				.frame(width: 75, height: 15)
				.foregroundColor(.gray) // Background bar

			Rectangle()
				.frame(width: healthPercentage, height: 15) // Adjust width dynamically
				.foregroundColor(.red) // Health bar
		}
		.cornerRadius(5)
	}
}
