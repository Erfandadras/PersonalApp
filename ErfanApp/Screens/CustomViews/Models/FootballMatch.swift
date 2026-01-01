//
//  FootballMatch.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 12/31/25.
//

import Foundation

// MARK: - Football Match Model
/// Represents a live football/soccer match data structure.
/// Used for real-time match updates from Firebase Realtime Database.
struct FootballMatch: Codable, Sendable {
    
    // MARK: - Properties
    
    /// Home team name.
    let homeTeam: String
    
    /// Away team name.
    let awayTeam: String
    
    /// Home team's current score.
    let homeScore: Int
    
    /// Away team's current score.
    let awayScore: Int
    
    /// Current game time in seconds.
    let gameTime: Int
    
    // MARK: - Coding Keys
    
    /// Custom JSON key mapping for Firebase data structure.
    enum CodingKeys: String, CodingKey {
        case homeTeam = "home"
        case awayTeam = "away"
        case homeScore
        case awayScore
        case gameTime = "time"
    }
    
    // MARK: - Initialization
    
    init(homeTeam: String, awayTeam: String, homeScore: Int, awayScore: Int, gameTime: Int) {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.homeScore = homeScore
        self.awayScore = awayScore
        self.gameTime = gameTime
    }
    
    /// Decodes match data with default values for missing fields.
    /// Ensures graceful handling of incomplete Firebase data.
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.homeTeam = try container.decodeIfPresent(String.self, forKey: .homeTeam) ?? ""
        self.awayTeam = try container.decodeIfPresent(String.self, forKey: .awayTeam) ?? ""
        self.homeScore = try container.decodeIfPresent(Int.self, forKey: .homeScore) ?? 0
        self.awayScore = try container.decodeIfPresent(Int.self, forKey: .awayScore) ?? 0
        self.gameTime = try container.decodeIfPresent(Int.self, forKey: .gameTime) ?? 0
    }
}

// MARK: - Computed Properties
extension FootballMatch {
    
    /// Formatted game time display (e.g., "45'" for minute 45).
    var formattedGameTime: String {
        "\(gameTime / 60)'"
    }
    
    /// Score display string (e.g., "2 - 1").
    var scoreDisplay: String {
        "\(homeScore) - \(awayScore)"
    }
    
    /// Abbreviated home team name (first 3 characters).
    var homeTeamAbbr: String {
        String(homeTeam.prefix(3)).uppercased()
    }
    
    /// Abbreviated away team name (first 3 characters).
    var awayTeamAbbr: String {
        String(awayTeam.prefix(3)).uppercased()
    }
}

// MARK: - Sample Data
extension FootballMatch {
    
    /// Sample data for previews and testing.
    static let sample = FootballMatch(
        homeTeam: "Real Madrid",
        awayTeam: "Barcelona",
        homeScore: 2,
        awayScore: 1,
        gameTime: 5100
    )
}
