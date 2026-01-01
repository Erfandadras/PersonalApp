//
//  LiveActivityViewModel.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 12/31/25.
//

import Foundation
import Combine
import ActivityKit
import SwiftUI
import ServiceModule
import BaseModule

// MARK: - Live Activity ViewModel
/// Manages the lifecycle and state of multiple Live Activity instances.
/// Supports football, music, chat, and general activity types with real-time Firebase updates.
@MainActor
final class LiveActivityViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Active football match Live Activity instance.
    @Published private(set) var footballActivity: Activity<FootballActivityAttributes>?
    
    /// Active music player Live Activity instance.
    @Published private(set) var musicActivity: Activity<MusicActivityAttributes>?
    
    /// Active chat Live Activity instance.
    @Published private(set) var chatActivity: Activity<ChatActivityAttributes>?
    
    /// Active general progress Live Activity instance.
    @Published private(set) var generalActivity: Activity<GeneralActivityAttributes>?
    
    /// Indicates whether Live Activities are supported on this device.
    @Published private(set) var isSupported: Bool = true
    
    // MARK: - Private Properties
    
    /// Firebase database service for real-time match updates.
    private let dbService: FirebaseDatabaseServiceProtocol
    
    /// Task handle for football match observation, used for cancellation.
    private var footballObservationTask: Task<Void, Never>?
    
    // MARK: - Initialization
    
    init(dbService: FirebaseDatabaseServiceProtocol = FirebaseDatabaseService()) {
        self.dbService = dbService
        checkActivitySupport()
    }
    
    deinit {
        footballObservationTask?.cancel()
    }
    
    // MARK: - Public Interface
    
    /// Checks if a specific activity type is currently active.
    /// - Parameter type: The activity type to check.
    /// - Returns: `true` if the activity is running, `false` otherwise.
    func isActivityActive(_ type: LiveActivityType) -> Bool {
        switch type {
        case .football: return footballActivity != nil
        case .music: return musicActivity != nil
        case .chat: return chatActivity != nil
        case .general: return generalActivity != nil
        }
    }
    
    /// Toggles the activity state for the specified type.
    /// Starts the activity if inactive, stops it if active.
    /// - Parameter type: The activity type to toggle.
    func toggleActivity(_ type: LiveActivityType) {
        if isActivityActive(type) {
            stopActivity(type)
        } else {
            startActivity(type)
        }
    }
    
    // MARK: - Private Methods
    
    /// Verifies Live Activity support on the current device.
    private func checkActivitySupport() {
        isSupported = ActivityAuthorizationInfo().areActivitiesEnabled
    }
    
    /// Starts a Live Activity for the specified type.
    /// - Parameter type: The activity type to start.
    private func startActivity(_ type: LiveActivityType) {
        guard isSupported else {
            Logger.log(.function, level: .warning, "Live Activities not supported on this device")
            return
        }
        
        do {
            switch type {
            case .football:
                startFootballActivity()
                
            case .music:
                let attributes = MusicActivityAttributes(activityId: UUID().uuidString)
                let initialState = MusicActivityAttributes.ContentState(
                    songName: "Starboy",
                    artist: "The Weeknd",
                    progress: 0.5,
                    isPlaying: true
                )
                musicActivity = try Activity.request(
                    attributes: attributes,
                    content: .init(state: initialState, staleDate: nil)
                )
                Logger.log(.function, level: .success, "Music activity started")
                
            case .chat:
                let attributes = ChatActivityAttributes(activityId: UUID().uuidString)
                let initialState = ChatActivityAttributes.ContentState(
                    senderName: "Alex",
                    lastMessage: "Hello!"
                )
                chatActivity = try Activity.request(
                    attributes: attributes,
                    content: .init(state: initialState, staleDate: nil)
                )
                Logger.log(.function, level: .success, "Chat activity started")
                
            case .general:
                let attributes = GeneralActivityAttributes(activityId: UUID().uuidString)
                let initialState = GeneralActivityAttributes.ContentState(
                    title: "Task Progress",
                    message: "Processing...",
                    progress: 0.3
                )
                generalActivity = try Activity.request(
                    attributes: attributes,
                    content: .init(state: initialState, staleDate: nil)
                )
                Logger.log(.function, level: .success, "General activity started")
            }
        } catch {
            Logger.log(.function, level: .error, "Failed to start \(type.rawValue): \(error.localizedDescription)")
        }
    }
    
    /// Starts the football activity with initial loading state and begins Firebase observation.
    private func startFootballActivity() {
        do {
            let attributes = FootballActivityAttributes(activityId: UUID().uuidString)
            let loadingState = FootballActivityAttributes.ContentState(
                homeTeam: "Loading...",
                awayTeam: "...",
                homeScore: 0,
                awayScore: 0,
                gameTime: 0
            )
            footballActivity = try Activity.request(
                attributes: attributes,
                content: .init(state: loadingState, staleDate: nil)
            )
            startObservingFootballMatch()
            Logger.log(.function, level: .success, "Football activity started with Firebase observation")
        } catch {
            Logger.log(.function, level: .error, "Failed to start football activity: \(error.localizedDescription)")
        }
    }
    
    /// Stops the Live Activity for the specified type.
    /// - Parameter type: The activity type to stop.
    private func stopActivity(_ type: LiveActivityType) {
        Task {
            switch type {
            case .football:
                await footballActivity?.end(nil, dismissalPolicy: .immediate)
                footballActivity = nil
                cancelFootballObservation()
                Logger.log(.function, level: .info, "Football activity stopped")
                
            case .music:
                await musicActivity?.end(nil, dismissalPolicy: .immediate)
                musicActivity = nil
                Logger.log(.function, level: .info, "Music activity stopped")
                
            case .chat:
                await chatActivity?.end(nil, dismissalPolicy: .immediate)
                chatActivity = nil
                Logger.log(.function, level: .info, "Chat activity stopped")
                
            case .general:
                await generalActivity?.end(nil, dismissalPolicy: .immediate)
                generalActivity = nil
                Logger.log(.function, level: .info, "General activity stopped")
            }
        }
    }
    
    /// Cancels the Firebase observation task for football matches.
    private func cancelFootballObservation() {
        footballObservationTask?.cancel()
        footballObservationTask = nil
    }
    
    // MARK: - Firebase Real-time Observation
    
    /// Starts observing football match updates from Firebase Realtime Database.
    /// Updates the Live Activity content state whenever new data arrives.
    private func startObservingFootballMatch() {
        footballObservationTask = Task { [weak self] in
            guard let self else { return }
            
            do {
                let matchPath = "/football/-kajsnkandkjasd"
                for try await match: FootballMatch in dbService.observe(database: .base, path: matchPath) {
                    await self.updateFootballActivity(with: match)
                }
            } catch {
                if !Task.isCancelled {
                    Logger.log(.function, level: .error, "Football observation error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Updates the football Live Activity with new match data.
    /// - Parameter match: The latest football match data from Firebase.
    private func updateFootballActivity(with match: FootballMatch) async {
        guard let activity = footballActivity else { return }
        
        let updatedState = FootballActivityAttributes.ContentState(
            homeTeam: match.homeTeam,
            awayTeam: match.awayTeam,
            homeScore: match.homeScore,
            awayScore: match.awayScore,
            gameTime: match.gameTime
        )
        
        await activity.update(.init(state: updatedState, staleDate: nil))
        Logger.log(.function, level: .info, "Football activity updated: \(updatedState.scoreDisplay)")
    }
}

