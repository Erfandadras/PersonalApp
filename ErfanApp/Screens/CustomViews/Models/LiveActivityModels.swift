//
//  LiveActivityModels.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 12/30/25.
//

import ActivityKit
import SwiftUI

// MARK: - Live Activity Type
/// Defines the supported Live Activity demo types with associated metadata.
/// Each type represents a distinct Live Activity configuration for the Dynamic Island and Lock Screen.
public enum LiveActivityType: String, Codable, CaseIterable, Sendable {
    case general = "General"
    case football = "Football Match"
    case music = "Music Player"
    case chat = "Live Chat"
    
    /// SF Symbol icon representing this activity type.
    public var icon: String {
        switch self {
        case .general: return "timer"
        case .football: return "sportscourt.fill"
        case .music: return "music.note"
        case .chat: return "bubble.left.fill"
        }
    }
    
    /// Accent color associated with this activity type.
    public var accentColor: Color {
        switch self {
        case .general: return .blue
        case .football: return .green
        case .music: return .purple
        case .chat: return .cyan
        }
    }
}

// MARK: - Football Activity Attributes
/// ActivityKit attributes for live football/soccer match tracking.
/// Displays real-time match scores and game time in the Dynamic Island.
public struct FootballActivityAttributes: ActivityAttributes {
    
    /// Dynamic content state for football match updates.
    public struct ContentState: Codable, Hashable, Sendable {
        public var homeTeam: String
        public var awayTeam: String
        public var homeScore: Int
        public var awayScore: Int
        public var gameTime: Int  // Game time in seconds
        
        public init(homeTeam: String, awayTeam: String, homeScore: Int, awayScore: Int, gameTime: Int) {
            self.homeTeam = homeTeam
            self.awayTeam = awayTeam
            self.homeScore = homeScore
            self.awayScore = awayScore
            self.gameTime = gameTime
        }
        
        /// Formatted game time display (e.g., "85'" for minute 85).
        public var formattedGameTime: String {
            "\(gameTime / 60)'"
        }
        
        /// Score display string (e.g., "2 - 1").
        public var scoreDisplay: String {
            "\(homeScore) - \(awayScore)"
        }
        
        /// Sample data for previews and testing.
        public static let sample = Self(
            homeTeam: "RMA",
            awayTeam: "BAR",
            homeScore: 2,
            awayScore: 1,
            gameTime: 5100
        )
    }
    
    public var activityId: String
    
    public init(activityId: String) {
        self.activityId = activityId
    }
}

// MARK: - Music Activity Attributes
/// ActivityKit attributes for music playback visualization.
/// Displays current track info and playback progress in the Dynamic Island.
public struct MusicActivityAttributes: ActivityAttributes {
    
    /// Dynamic content state for music playback updates.
    public struct ContentState: Codable, Hashable, Sendable {
        public var songName: String
        public var artist: String
        public var progress: Double  // 0.0 to 1.0
        public var isPlaying: Bool
        
        public init(songName: String, artist: String, progress: Double, isPlaying: Bool) {
            self.songName = songName
            self.artist = artist
            self.progress = min(max(progress, 0.0), 1.0)  // Clamp to valid range
            self.isPlaying = isPlaying
        }
        
        /// Progress as percentage string (e.g., "62%").
        public var progressPercentage: String {
            "\(Int(progress * 100))%"
        }
        
        /// Sample data for previews and testing.
        public static let sample = Self(
            songName: "Starboy",
            artist: "The Weeknd",
            progress: 0.62,
            isPlaying: true
        )
    }
    
    public var activityId: String
    
    public init(activityId: String) {
        self.activityId = activityId
    }
}

// MARK: - Chat Activity Attributes
/// ActivityKit attributes for live chat/messaging notifications.
/// Displays sender info and latest message in the Dynamic Island.
public struct ChatActivityAttributes: ActivityAttributes {
    
    /// Dynamic content state for chat message updates.
    public struct ContentState: Codable, Hashable, Sendable {
        public var senderName: String
        public var lastMessage: String
        public var avatarUrl: String?
        
        public init(senderName: String, lastMessage: String, avatarUrl: String? = nil) {
            self.senderName = senderName
            self.lastMessage = lastMessage
            self.avatarUrl = avatarUrl
        }
        
        /// First letter of sender name for avatar placeholder.
        public var senderInitial: String {
            senderName.prefix(1).uppercased()
        }
        
        /// Sample data for previews and testing.
        public static let sample = Self(
            senderName: "Alex",
            lastMessage: "See you soon!"
        )
    }
    
    public var activityId: String
    
    public init(activityId: String) {
        self.activityId = activityId
    }
}

// MARK: - General Activity Attributes
/// ActivityKit attributes for generic progress tracking activities.
/// Displays title, message, and progress indicator in the Dynamic Island.
public struct GeneralActivityAttributes: ActivityAttributes {
    
    /// Dynamic content state for general progress updates.
    public struct ContentState: Codable, Hashable, Sendable {
        public var title: String
        public var message: String
        public var progress: Double  // 0.0 to 1.0
        
        public init(title: String, message: String, progress: Double) {
            self.title = title
            self.message = message
            self.progress = min(max(progress, 0.0), 1.0)  // Clamp to valid range
        }
        
        /// Progress as percentage string (e.g., "78%").
        public var progressPercentage: String {
            "\(Int(progress * 100))%"
        }
        
        /// Sample data for previews and testing.
        public static let sample = Self(
            title: "Building…",
            message: "Compiling assets",
            progress: 0.78
        )
    }
    
    public var activityId: String
    
    public init(activityId: String) {
        self.activityId = activityId
    }
}
