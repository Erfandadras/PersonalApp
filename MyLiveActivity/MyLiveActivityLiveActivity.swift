//
//  MyLiveActivityLiveActivity.swift
//  MyLiveActivity
//
//  Created by Erfan mac mini on 12/30/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

// MARK: - Widget Bundle
/// Main entry point for Live Activity widgets.
/// Registers all supported activity configurations for the Dynamic Island.
@main
struct MyLiveActivityBundle: WidgetBundle {
    var body: some Widget {
        FootballLiveActivity()
        MusicLiveActivity()
        ChatLiveActivity()
        GeneralLiveActivity()
    }
}

// MARK: - Football Live Activity
/// Live Activity widget for real-time football/soccer match tracking.
/// Displays team names, scores, and game time in the Dynamic Island and Lock Screen.
struct FootballLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FootballActivityAttributes.self) { context in
            // Lock Screen presentation
            FootballLockScreenView(state: context.state)
                .padding()
                .activityBackgroundTint(.black.opacity(0.7))
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded layout
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.homeTeam.prefix(3).uppercased())
                        .font(.caption.bold())
                        .padding(.leading)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.awayTeam.prefix(3).uppercased())
                        .font(.caption.bold())
                        .padding(.trailing)
                }
                
                DynamicIslandExpandedRegion(.center) {
                    HStack(spacing: 8) {
                        Text("\(context.state.homeScore)")
                        Text("-")
                        Text("\(context.state.awayScore)")
                    }
                    .font(.title2.bold())
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.formattedGameTime)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            } compactLeading: {
                Text("\(context.state.homeScore)")
                    .font(.caption.bold())
            } compactTrailing: {
                Text("\(context.state.awayScore)")
                    .font(.caption.bold())
            } minimal: {
                Text("⚽️")
            }
            .keylineTint(.green)
        }
    }
}

// MARK: - Music Live Activity
/// Live Activity widget for music playback visualization.
/// Displays current track, artist, and playback progress in the Dynamic Island.
struct MusicLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MusicActivityAttributes.self) { context in
            // Lock Screen presentation
            MusicLockScreenView(state: context.state)
                .padding()
                .activityBackgroundTint(.black.opacity(0.7))
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded layout
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "music.note")
                        .foregroundColor(.purple)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Image(systemName: "waveform")
                        .foregroundColor(.purple)
                        .symbolEffect(.variableColor.iterative)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 4) {
                        Text(context.state.songName)
                            .font(.headline)
                        
                        Text(context.state.artist)
                            .font(.subheadline)
                            .opacity(0.7)
                        
                        ProgressView(value: context.state.progress)
                            .tint(.purple)
                    }
                }
            } compactLeading: {
                Image(systemName: context.state.isPlaying ? "pause.fill" : "play.fill")
                    .font(.caption2)
            } compactTrailing: {
                Image(systemName: "waveform")
                    .foregroundColor(.purple)
                    .symbolEffect(.variableColor.iterative)
            } minimal: {
                Image(systemName: "music.note")
                    .foregroundColor(.purple)
            }
            .keylineTint(.purple)
        }
    }
}

// MARK: - Chat Live Activity
/// Live Activity widget for real-time chat/messaging notifications.
/// Displays sender name and latest message in the Dynamic Island.
struct ChatLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ChatActivityAttributes.self) { context in
            // Lock Screen presentation
            ChatLockScreenView(state: context.state)
                .padding()
                .activityBackgroundTint(.black.opacity(0.7))
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded layout
                DynamicIslandExpandedRegion(.leading) {
                    Circle()
                        .fill(.cyan)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Text(context.state.senderInitial)
                                .font(.caption2.bold())
                                .foregroundColor(.white)
                        )
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Now")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(context.state.senderName)
                            .font(.headline)
                        
                        Text(context.state.lastMessage)
                            .font(.subheadline)
                            .lineLimit(1)
                            .opacity(0.8)
                    }
                }
            } compactLeading: {
                Circle()
                    .fill(.cyan)
                    .frame(width: 12, height: 12)
            } compactTrailing: {
                Text("msg")
                    .font(.caption2)
            } minimal: {
                Circle()
                    .fill(.cyan)
                    .frame(width: 12, height: 12)
            }
            .keylineTint(.cyan)
        }
    }
}

// MARK: - General Live Activity
/// Live Activity widget for generic progress tracking.
/// Displays title, message, and progress indicator in the Dynamic Island.
struct GeneralLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GeneralActivityAttributes.self) { context in
            // Lock Screen presentation
            GeneralLockScreenView(state: context.state)
                .padding()
                .activityBackgroundTint(.black.opacity(0.7))
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded layout
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "timer")
                        .foregroundColor(.blue)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.progressPercentage)
                        .font(.caption.bold())
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 4) {
                        Text(context.state.title)
                            .font(.headline)
                        
                        ProgressView(value: context.state.progress)
                            .tint(.blue)
                    }
                }
            } compactLeading: {
                Image(systemName: "timer")
                    .font(.caption2)
                    .foregroundColor(.blue)
            } compactTrailing: {
                Text(context.state.progressPercentage)
                    .font(.caption2)
            } minimal: {
                Image(systemName: "timer")
                    .foregroundColor(.blue)
            }
            .keylineTint(.blue)
        }
    }
}

// MARK: - Lock Screen Views

/// Lock Screen view for football match activity.
struct FootballLockScreenView: View {
    let state: FootballActivityAttributes.ContentState
    
    var body: some View {
        HStack {
            teamColumn(name: state.homeTeam, score: state.homeScore)
            
            Spacer()
            
            VStack(spacing: 4) {
                Text(state.formattedGameTime)
                    .foregroundColor(.red)
                    .font(.caption.bold())
                
                Text("vs")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            teamColumn(name: state.awayTeam, score: state.awayScore)
        }
        .foregroundColor(.white)
    }
    
    /// Reusable column for team name and score display.
    private func teamColumn(name: String, score: Int) -> some View {
        VStack(spacing: 4) {
            Text(name)
                .font(.headline)
            
            Text("\(score)")
                .font(.system(size: 40, weight: .bold))
        }
    }
}

/// Lock Screen view for music playback activity.
struct MusicLockScreenView: View {
    let state: MusicActivityAttributes.ContentState
    
    var body: some View {
        HStack(spacing: 16) {
            // Album art placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.purple.opacity(0.3))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "music.note")
                        .font(.title)
                        .foregroundColor(.purple)
                )
            
            // Track info
            VStack(alignment: .leading, spacing: 4) {
                Text(state.songName)
                    .font(.headline)
                
                Text(state.artist)
                    .font(.subheadline)
                    .opacity(0.8)
                
                ProgressView(value: state.progress)
                    .tint(.purple)
            }
            
            Spacer()
            
            // Playback control indicator
            Image(systemName: state.isPlaying ? "pause.fill" : "play.fill")
                .font(.title2)
                .foregroundColor(.purple)
        }
        .foregroundColor(.white)
    }
}

/// Lock Screen view for chat activity.
struct ChatLockScreenView: View {
    let state: ChatActivityAttributes.ContentState
    
    var body: some View {
        HStack(spacing: 12) {
            // Sender avatar
            Circle()
                .fill(Color.cyan)
                .frame(width: 44, height: 44)
                .overlay(
                    Text(state.senderInitial)
                        .font(.headline)
                        .foregroundColor(.white)
                )
            
            // Message content
            VStack(alignment: .leading, spacing: 4) {
                Text(state.senderName)
                    .font(.headline)
                
                Text(state.lastMessage)
                    .font(.subheadline)
                    .opacity(0.8)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text("Now")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .foregroundColor(.white)
    }
}

/// Lock Screen view for general progress activity.
struct GeneralLockScreenView: View {
    let state: GeneralActivityAttributes.ContentState
    
    var body: some View {
        HStack(spacing: 12) {
            // Timer icon
            Image(systemName: "timer")
                .font(.title)
                .foregroundColor(.blue)
            
            // Progress info
            VStack(alignment: .leading, spacing: 4) {
                Text(state.title)
                    .font(.headline)
                
                Text(state.message)
                    .font(.subheadline)
                    .opacity(0.8)
            }
            
            Spacer()
            
            // Circular progress indicator
            CircularProgressView(progress: state.progress, color: .blue)
                .frame(width: 44, height: 44)
        }
        .foregroundColor(.white)
    }
}

// MARK: - Circular Progress View
/// Circular progress indicator for visual progress representation.
struct CircularProgressView: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 4)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, lineWidth: 4)
                .rotationEffect(.degrees(-90))
        }
    }
}
