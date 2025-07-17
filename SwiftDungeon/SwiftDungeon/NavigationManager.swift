import SwiftUI

/// An entity to control navigation flow in the app
///
/// Should be constructed in composition root and injected via init into ViewModels of the modules we want be able to navigate through
final class NavigationManager {

	// MARK: - Properties

	/// NavigationStack to hold screens
	///
	/// May be should be `private` to avoid direct access by the owners (viewModels)
	/// May be should not be `@Published` to avoid exposing
	@Published var path = NavigationPath()

	/// Computed property to check is there an items in stack or it's empty
	var isEmpty: Bool { path.isEmpty }

	/// Computer property to define current number of items in stack
	var count: Int { path.count }

	// MARK: - Methods

	/// Method to extract current NavigationPath without direct access
	func getPath() -> NavigationPath {
		return path
	}

	/// Push Screen to the stack
	func push(_ screen: AppScreen) {
		path.append(screen)
		print("🔍 Path now has \(path.count) entries: \(path)")
	}

	/// Check if stack is not empty and remove screen on the top of it
	func pop() {
		guard !isEmpty else { return }
		path.removeLast()
		print("🔍 Path now has \(path.count) entries: \(path)")
	}

	/// Clear an entire stack
	func reset() {
		path = NavigationPath()
	}
}
