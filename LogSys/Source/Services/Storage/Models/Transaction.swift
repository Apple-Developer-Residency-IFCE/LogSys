//
//  Transaction.swift
//  LogSys
//
//  Created by Pedro Sousa on 16/09/25.
//

import SwiftData
import Foundation

@Model
class Transaction {
    private(set) var identifier: UUID
    private(set) var origin: String
    private(set) var destination: String
    private(set) var value: Double
    private(set) var date: Date

    init(identifier: UUID, origin: String, destination: String, value: Double, date: Date) {
        self.identifier = identifier
        self.origin = origin
        self.destination = destination
        self.value = value
        self.date = date
    }
}
