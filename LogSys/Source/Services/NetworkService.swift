//
//  NetworkService.swift
//  LogSys
//
//  Created by Pedro Sousa on 15/09/25.
//

import Foundation
import OSLog

class NetworkService {
    static let shared = NetworkService()

    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request(url: URL, data: Data? = nil) async throws -> Data {
        LoggerService.shared.info("Data request called to \(url)")

        var request = URLRequest(url: url)
        request.httpBody = data
        let (data, _) = try await session.data(for: request)
        return data
    }
}
