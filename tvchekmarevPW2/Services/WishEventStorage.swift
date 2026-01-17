//
//  WishEventStorage.swift
//  tvchekmarevPW2
//
//  Created by Трофим Чекмарев on 17.01.2026.
//

import CoreData

final class WishEventStorage {

    // MARK: - Constants
    private enum Constants {
        static let modelName: String = "WishEventDataModel"
        static let createdAtKey: String = "createdAt"
    }

    // MARK: - Singleton
    static let shared = WishEventStorage()

    // MARK: - Core Data
    private let container: NSPersistentContainer

    private var context: NSManagedObjectContext {
        container.viewContext
    }

    // MARK: - Lifecycle
    private init() {
        container = NSPersistentContainer(name: Constants.modelName)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData load error: \(error)")
            }
        }
    }

    // MARK: - Fetch
    func fetchEvents() -> [WishEventModel] {
        let request: NSFetchRequest<WishEventEntity> = WishEventEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: Constants.createdAtKey, ascending: false)]

        do {
            let objects = try context.fetch(request)
            return objects.compactMap { obj in
                guard
                    let title = obj.title,
                    let start = obj.startDateText,
                    let end = obj.endDateText
                else {
                    return nil
                }

                return WishEventModel(
                    title: title,
                    description: obj.details ?? "",
                    startDate: start,
                    endDate: end
                )
            }
        } catch {
            return []
        }
    }

    // MARK: - Add
    func addEvent(_ event: WishEventModel) {
        let object = WishEventEntity(context: context)
        object.title = event.title
        object.details = event.description
        object.startDateText = event.startDate
        object.endDateText = event.endDate
        object.createdAt = Date()
        save()
    }

    // MARK: - Save
    private func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch { }
    }
}
