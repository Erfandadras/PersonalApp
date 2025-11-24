//
//  Logger.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/24/25.
//


import Foundation

public enum AppLifeCycle: String {
    case enterForeground
    case enterBackGround
    case terminated
    case launched
    case willFinishLaunching
    case didFinishLaunchingWithOptions
}

public enum LogEvent {
    case custom(flow: String)
    case function
    case lifeCycle(AppLifeCycle)
    case className
    case request
    case socket
    
    var str: String {
        switch self {
        case .custom(let userFlow):
            return userFlow
            
        case .className:
            return ""
            
        case .lifeCycle(let cycle):
            return cycle.rawValue
            
        case .function:
            return ""
            
        case .request:
            return "Request"
        case .socket:
            return "Socket"
        }
    }
}

public enum LogLevel {
    case error, success , info, warning, custom(message: String)
    var event: String {
        switch self {
        case .error:
            return "Error"
        case .success:
            return "Success"
        case .info:
            return "Info"
        case .warning:
            return "Warning"
        case .custom(let message):
            return message
        }
    }
    
    var icon: String {
        switch self {
        case .error:
            return "❌"
        case .success:
            return "✅"
        case .info:
            return "✏️"
        case .warning:
            return "⚠️"
        default:
            return ""
        }
    }
}

public struct Logger {
    @Injected static var userManager: UserManager
    static var uid: String? {
        userManager.userId?.description
    }
    
    public static func log(_ event: LogEvent,
                           level: LogLevel,
                           file: String = #file,
                           function: String = #function,
                           line: Int = #line, _ messages: Any...) {
         // Construct log message with source location information
        let filePart = file.components(separatedBy: "/").last ?? ""
        let logMessage: String
        
        // Append the variadic messages to the log message
        let formattedMessage = messages.map { String(describing: $0) }.joined(separator: " + ")
        logMessage = "[\(event.str),\(level.event + level.icon) >>>> on \(filePart) -> \(function) line \(line)"
        
         // Combine source location information and messages
        let finalMessage = logMessage + " msg: " + formattedMessage + "]"
        
        // Log to NSLog for local debugging
        var eventStr = event.str
        if case .function = event {
            eventStr = function
        } else if case .className = event {
            eventStr = filePart
        }
        eventStr += "_"
        eventStr += level.event
        
        print(eventStr, finalMessage)
    }
}

