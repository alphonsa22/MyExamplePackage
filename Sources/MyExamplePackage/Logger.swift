//
//  File.swift
//  
//
//  Created by Alphonsa Varghese on 21/06/23.
//

import Foundation
import SwiftUI
import CoreData

public enum LogLevel: Int {
    case verbose
    case debug
    case info
    case warning
    case error
}

public enum LogFormat {
    case standard
    case simple
    case custom(String)
}

public struct Logger {
    public static var logLevel: LogLevel = .debug
    public static var logFormat: LogFormat = .standard
    public static var logFileURL: URL? = nil
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    public static func log(_ message: String, level: LogLevel, file: String = #file, function: String = #function, line: Int = #line) {
        if level.rawValue >= logLevel.rawValue {
            let logMessage = formatLogMessage(message, level: level, file: file, function: function, line: line)
            print(logMessage)
            DispatchQueue.main.async {
                showLogAsToast(logMessage)
            }
            
//            writeLogToFile(logMessage)
            saveLogToDatabase(logMessage)
        }
    }
    
    private static func formatLogMessage(_ message: String, level: LogLevel, file: String, function: String, line: Int) -> String {
        let timestamp = dateFormatter.string(from: Date())
        let fileName = (file as NSString).lastPathComponent
        let logLevelString = levelToString(level)
        
        switch logFormat {
        case .standard:
            return "\(timestamp) [\(logLevelString)] \(fileName) -> \(function) [Line \(line)]: \(message)"
        case .simple:
            return "\(timestamp) [\(logLevelString)]: \(message)"
        case .custom(let format):
            let formattedMessage = format.replacingOccurrences(of: "%timestamp%", with: timestamp)
                .replacingOccurrences(of: "%level%", with: logLevelString)
                .replacingOccurrences(of: "%file%", with: fileName)
                .replacingOccurrences(of: "%function%", with: function)
                .replacingOccurrences(of: "%line%", with: "\(line)")
                .replacingOccurrences(of: "%message%", with: message)
            return formattedMessage
        }
    }
    
    private static func levelToString(_ level: LogLevel) -> String {
        switch level {
        case .verbose:
            return "VERBOSE"
        case .debug:
            return "DEBUG"
        case .info:
            return "INFO"
        case .warning:
            return "WARNING"
        case .error:
            return "ERROR"
        }
    }
    
    private static func writeLogToFile(_ logMessage: String) {
        guard let logFileURL = logFileURL else {
            return
        }
        
        do {
            let fileHandle = try FileHandle(forWritingTo: logFileURL)
            fileHandle.seekToEndOfFile()
            fileHandle.write(logMessage.data(using: .utf8)!)
            fileHandle.closeFile()
        } catch {
            print("Error writing log to file: \(error)")
        }
    }
    
    private static func showLogAsToast(_ logMessage: String) {
        NotificationCenter.default.post(name: NSNotification.Name("ShowToast"), object: logMessage)
    }
    
    private static func saveLogToDatabase(_ logMessage: String) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let logEntity = LoggerEntity(context: context)
        logEntity.timestamp = Date()
        logEntity.logMessage = logMessage
        
        do {
            try context.save()
            print("successfully updated")
        } catch {
            print("Error saving log to database: \(error)")
        }
    }

}

    

           

