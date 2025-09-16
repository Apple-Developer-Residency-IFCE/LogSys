//
//  StorageService.swift
//  LogSys
//
//  Created by Pedro Sousa on 16/09/25.
//


import Foundation
import SwiftData

@MainActor
class StorageService {
    static let shared = StorageService()

    static let schema = Schema([Transaction.self])
    private let container: ModelContainer?

    var isInitialized: Bool { container != nil }
    var context: ModelContext? { container?.mainContext }

    init(inMemory: Bool = false) {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: inMemory)

        do {
            self.container = try ModelContainer(for: StorageService.schema, configurations: configuration)
            LoggerService.shared.info("Database container initialized successfully")
        } catch {
            self.container = nil
            LoggerService.shared.error("Database container failed initialization. \(error.localizedDescription)")
        }
    }

    func getAll<Model: PersistentModel>() -> [Model] {
        (try? context?.fetch(FetchDescriptor<Model>())) ?? []
    }

    func getAll<Model: PersistentModel>(where predicate: Predicate<Model>) -> [Model] {
        (try? context?.fetch(FetchDescriptor<Model>(predicate: predicate))) ?? []
    }

    func getById<Model: PersistentModel>(_ id: PersistentIdentifier) -> Model? {
        if let model: Model = context?.registeredModel(for: id) {
            return model
        }

        return getAll(where: #Predicate { $0.persistentModelID == id }).first
    }

    func create<Model: PersistentModel>(_ model: Model) {
        context?.insert(model)
    }

    func delete<Model: PersistentModel>(_ model: Model) {
        context?.delete(model)
    }

    @discardableResult
    func save() -> Bool {
        do {
            try context?.save()
            return true
        } catch {
            return false
        }
    }
}
