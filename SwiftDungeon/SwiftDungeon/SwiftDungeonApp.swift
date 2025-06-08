import SwiftUI

// MARK: Initial Point of the App

@main
struct SwiftDungeonApp: App {

	// MARK: Compositional Root accordingly to Mark Seeman

	let appDependencies = AppDependencies()

	// MARK: - Body
	
    var body: some Scene {

        WindowGroup {

			appDependencies.buildMenu()

        }
    }
}
