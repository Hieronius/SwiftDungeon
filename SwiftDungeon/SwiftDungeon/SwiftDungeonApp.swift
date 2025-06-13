import SwiftUI

// MARK: Initial Point of the App

@main
struct SwiftDungeonApp: App {

	// MARK: Compositional Root accordingly to Mark Seeman

	let appDependencies = CompositionRoot()

	// MARK: - Body
	
	var body: some Scene {

		WindowGroup {

			appDependencies.buildMenu()

		}
	}
}
