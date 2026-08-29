//
//  Logs.swift
//  Radiola
//
//  Created by Alex Sokolov on 26.07.2026.
//

import Foundation

/* ****************************************
 *
 * ****************************************/
actor LogStorage {
    static let shared = LogStorage()

    private var logs: [String] = []

    func append(_ line: String) {
        logs.append(line)
    }

    func getAll() -> [String] {
        return logs
    }
}

/* ****************************************
 *
 * ****************************************/
func allLogs() async -> [String] {
    return await LogStorage.shared.getAll()
}

/* ****************************************
 *
 * ****************************************/
private let logDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    formatter.timeZone = .current
    return formatter
}()

/* ****************************************
 *
 * ****************************************/
fileprivate func logMsg(prefix: String, _ items: Any..., separator: String = " ", terminator: String = "\n") {
    let timestamp = logDateFormatter.string(from: Date())
    let threadId = pthread_mach_thread_np(pthread_self())
    let payload = items.map { "\($0)" }.joined(separator: separator)

    let s = "\(prefix): \(timestamp) [\(threadId)] \(payload)"
    Task {
        await LogStorage.shared.append(s)
    }
    print(s)
}

/* ****************************************
 *
 * ****************************************/
func debug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    logMsg(prefix: "Debug", items, separator: separator, terminator: terminator)
}

/* ****************************************
 *
 * ****************************************/
func warning(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    logMsg(prefix: "Warning", items, separator: separator, terminator: terminator)
}
