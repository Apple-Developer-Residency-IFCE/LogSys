//
//  LoggerService.swift
//  LogSys
//
//  Created by Pedro Sousa on 15/09/25.
//

import Foundation

enum LogType: String, CaseIterable {
    case debug
    case info
    case warning
    case error
}

class LoggerService {
    public static let shared = LoggerService()

    private static let logName = "log_sys.log"
    private static let logURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                                                   .first!
                                                   .appending(path: LoggerService.logName)

    private let dateFormatter = ISO8601DateFormatter()
    private var handle: FileHandle? = nil

    var isReady: Bool { handle != nil }

    private init() {}

    deinit {
        try? handle?.close()
    }

    func setup() {
        do {
            let path = LoggerService.logURL.path()
            if !FileManager.default.fileExists(atPath: path),
               FileManager.default.createFile(atPath: path, contents: nil) {
                self.info("LoggerService: file created successfully.")
            } else {
                if FileManager.default.fileExists(atPath: path) {
                    self.warning("LoggerService: log file already exists.")
                } else {
                    self.error("LoggerService: unable to create log file.")
                }
            }

            self.handle = try FileHandle(forWritingTo: LoggerService.logURL)
            try self.handle?.seekToEnd()
            self.info("LoggerService: opened log file.")
        } catch {
            self.error("LoggerService: init failed. \(error.localizedDescription)")
            self.handle = nil
        }
    }

    func clear() {
        do {
            try FileManager.default.removeItem(at: LoggerService.logURL)
            FileManager.default.createFile(atPath: LoggerService.logURL.path(), contents: nil)

            self.handle = try FileHandle(forWritingTo: LoggerService.logURL)
            try self.handle?.seekToEnd()
            print("LoggerService: log file cleared and reopened.")
        } catch {
            print("LoggerService: init failed. \(error.localizedDescription)")
            self.handle = nil
        }
    }

    func export() -> Data? {
        return try? Data(contentsOf: LoggerService.logURL)
    }

    func log(_ message: String, type: LogType = .info) {
        let logString = "\(dateFormatter.string(from: Date())) [\(type.rawValue)] \(message)\n"
        #if DEBUG
        print(logString)
        #endif
        handle?.write(logString.data(using: .utf8)!)
    }

    func debug(_ message: String) {
        log(message, type: .debug)
    }

    func info(_ message: String) {
        log(message, type: .info)
    }

    func warning(_ message: String) {
        log(message, type: .warning)
    }

    func error(_ message: String) {
        log(message, type: .error)
    }
}
