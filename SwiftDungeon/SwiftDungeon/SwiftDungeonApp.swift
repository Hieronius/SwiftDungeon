import SwiftUI

// MARK: Initial Point of the App

@main
struct SwiftDungeonApp: App {

    var body: some Scene {
		
        WindowGroup {

			RoomBuilder.build()
        }
    }
}
