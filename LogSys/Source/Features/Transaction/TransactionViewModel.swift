//
//  TransactionViewModel.swift
//  LogSys
//
//  Created by Pedro Sousa on 16/09/25.
//

import Foundation
import Observation

@MainActor
@Observable
class TransactionViewModel {
    var transactions: [Transaction] = []

    @ObservationIgnored let networkService: NetworkService
    @ObservationIgnored let storageService: StorageService

    init(networkService: NetworkService,
         storageService: StorageService) {
        self.networkService = networkService
        self.storageService = storageService
    }

    func getTansactions() {
        self.transactions = self.storageService.getAll()
    }

    func makeTransaction() {
        let transaction = Transaction(identifier: .init(),
                                      origin: UUID().uuidString,
                                      destination: UUID().uuidString,
                                      value: Double(Int.random(in: 30...500)),
                                      date: Date())

        storageService.create(transaction)

        if storageService.save() {
            LoggerService.shared.info("Transaction from \(transaction.origin) to \(transaction.destination) made successfully")
            self.transactions.append(transaction)
        } else {
            LoggerService.shared.error("Error while performin transaction from \(transaction.origin) to \(transaction.destination)")
        }
    }

    func shareLog() {
        if let logTimestamp = UserDefaults.standard.object(forKey: "logTimestamp") as? Date,
           Calendar.current.isDateInToday(logTimestamp) {
            LoggerService.shared.info("Log shared today")
        }

        Task {
            do {
                let logData = LoggerService.shared.export() ?? Data()
                _ = try await networkService.request(url: URL(string: "https://example.com/api/log")!, data: logData)
                UserDefaults.standard.set(Date(), forKey: "logTimestamp")
                LoggerService.shared.info("Log shared successfully")
            } catch {
                LoggerService.shared.error("Log not shared")
            }
        }
    }
}
