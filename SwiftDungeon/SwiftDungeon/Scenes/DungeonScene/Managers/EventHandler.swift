import Foundation

/// Entity to handle all kinds of events user might encounter by moving through the dungeon map
class EventHandler {

	func handleEvent(_ event: EventType) -> EventResult {

		switch event {

		case .enemy:
			return EventResult(result: "start fight")

		case .quest:
			return EventResult(result: "get/complete quest")

		case .reward:
			return EventResult(result: "get a reward for quest, monster or chest")

		case .riddle:
			return EventResult(result: "solve the riddle")

		case .trap:
			return EventResult(result: "Try to dissarray the trap")
		}
	}
}
