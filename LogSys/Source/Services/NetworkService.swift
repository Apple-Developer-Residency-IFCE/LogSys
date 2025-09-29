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

    func upload(url: URL, data: Data? = nil) {
        guard let data else { return }
        LoggerService.shared.info("Data request called to \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        session.uploadTask(with: request, from: data).resume()
    }
}
