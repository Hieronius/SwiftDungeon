import SwiftUI

@main
struct SwiftDungeonApp: App {

    var body: some Scene {
		
        WindowGroup {

			RoomBuilder.build()
        }
    }
}
