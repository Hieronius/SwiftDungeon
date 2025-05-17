import SwiftUI

// MARK: Initial Point of the App

@main
struct SwiftDungeonApp: App {


	// MARK: Dependencies

//	let roomGameStateSnapshot = RoomGameStateSnapshot()
//
//	let roomGameState = RoomGameState(
//		roomGameStateSnapshot: roomGameStateSnapshot)
//
//	let actionCalculator = ActionCalculator()
//	let actionHandler = ActionHandler(actionCalculator: actionCalculator)
//	let characterManager = CharacterManager()
//	let effectManager = EffectManager()
//	let turnManager = TurnManager()

	// let dungeonManager = DungeonManager()


    var body: some Scene {
		
        WindowGroup {

			// AppCordinator.assembly(screen: .MainScreen)

			// MainMenu(option: Options)

			// switch MainMenuoption

			// case newGame:
			// RoomBuilder.build(.Dungeon(dungeonManager: dungeonManager)

			// case town:
			// RoomBuilder.build(.Town(dungeonManager: dungeon)

			// case dungeon:
			// RoomBuilder.build(.Dungeon(dungeonManager: roomScreen.dungeonManager)

			RoomBuilder.build()
        }
    }
}
