import SwiftUI

struct ExperienceBar: View {

	var currentExperience: CGFloat // Value between 0 and 100
	var maxExperience: CGFloat

	private var experiencePercentage: CGFloat {
		guard maxExperience > 0 else { return 0 }
		guard currentExperience > 0 else { return 1 }
		return (currentExperience / maxExperience) * 100
	}

	var body: some View {
		ZStack(alignment: .leading) {
			Rectangle()
				.frame(width: 75, height: 15)
				.foregroundColor(.gray) // Background bar

			Rectangle()
				.frame(width: experiencePercentage, height: 15) // Adjust width dynamically
				.foregroundColor(.orange) // Health bar
		}
		.cornerRadius(5)
		.opacity(experiencePercentage > 0 ? 1 : 0)
	}
}
