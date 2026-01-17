//
//  CalendarManager.swift
//  tvchekmarevPW2
//
//  Created by Трофим Чекмарев on 17.01.2026.
//

import EventKit

// MARK: - CalendarManaging
protocol CalendarManaging {
    func create(eventModel: CalendarEventModel) -> Bool
}

// MARK: - CalendarEventModel
struct CalendarEventModel {
    var title: String
    var startDate: Date
    var endDate: Date
    var note: String?
}

// MARK: - CalendarManager
final class CalendarManager: CalendarManaging {

    // MARK: - Properties
    private let eventStore: EKEventStore = EKEventStore()

    // MARK: - Public
    func create(eventModel: CalendarEventModel) -> Bool {
        var result = false
        let group = DispatchGroup()
        group.enter()

        create(eventModel: eventModel) { isCreated in
            result = isCreated
            group.leave()
        }

        group.wait()
        return result
    }

    // MARK: - Private
    private func create(eventModel: CalendarEventModel, completion: ((Bool) -> Void)?) {

        // MARK: - Permission handler
        let handler: EKEventStoreRequestAccessCompletionHandler = { [weak self] granted, error in
            guard let self, granted, error == nil else {
                completion?(false)
                return
            }

            // MARK: - Event creation
            let event = EKEvent(eventStore: self.eventStore)
            event.title = eventModel.title
            event.startDate = eventModel.startDate
            event.endDate = eventModel.endDate
            event.notes = eventModel.note
            event.calendar = self.eventStore.defaultCalendarForNewEvents

            do {
                try self.eventStore.save(event, span: .thisEvent)
                completion?(true)
            } catch {
                print("Failed to save event: \(error)")
                completion?(false)
            }
        }

        // MARK: - Request access
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: handler)
        } else {
            eventStore.requestAccess(to: .event, completion: handler)
        }
    }
}
