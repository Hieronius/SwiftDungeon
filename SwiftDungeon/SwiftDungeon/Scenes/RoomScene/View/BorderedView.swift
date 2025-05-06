import SwiftUI

struct BorderedSection<Content: View>: View {
	let content: Content

	init(@ViewBuilder content: () -> Content) {
		self.content = content()
	}

	var body: some View {
		content
			.padding()
			.background(Color.black)
			.overlay(
				RoundedRectangle(cornerRadius: 8)
					.stroke(Color.gray, lineWidth: 2)
			)
			.padding(.horizontal, 16)
			.padding(.vertical, 4)
	}
}
