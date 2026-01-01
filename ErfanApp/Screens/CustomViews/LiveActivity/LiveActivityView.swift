//
//  LiveActivityView.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/13/25.
//

import SwiftUI
import ActivityKit
import BaseModule

// MARK: - Live Activity View
/// Main view for managing and previewing Live Activity demonstrations.
/// Provides controls to start/stop activities and previews of Dynamic Island layouts.
struct LiveActivityView: View {
    @StateObject private var viewModel = LiveActivityViewModel()
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if !viewModel.isSupported {
                unsupportedDeviceView
            } else {
                activityListView
            }
        }
    }
    
    // MARK: - Subviews
    
    /// Scrollable list of all activity type sections.
    private var activityListView: some View {
        ScrollView {
            VStack(spacing: 32) {
                headerSection
                activitySectionsStack
                Spacer(minLength: 50)
            }
            .padding()
        }
        .background(Color(white: 0.05).ignoresSafeArea())
    }
    
    /// Header with title and subtitle.
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Activity Lab")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Launch and manage multiple live sessions")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.top)
    }
    
    /// Stack containing all activity type sections.
    private var activitySectionsStack: some View {
        VStack(spacing: 40) {
            footballSection
            musicSection
            chatSection
            generalSection
        }
    }
    
    /// Football activity section with live match preview.
    private var footballSection: some View {
        ActivitySectionView(
            type: .football,
            isActive: viewModel.footballActivity != nil,
            onToggle: { viewModel.toggleActivity(.football) },
            expandedPreview: { MockFootballExpanded(state: .sample) },
            compactPreview: { MockFootballCompact(state: .sample) },
            minimalPreview: { MinimalIconView(emoji: "⚽️") }
        )
    }
    
    /// Music player activity section.
    private var musicSection: some View {
        ActivitySectionView(
            type: .music,
            isActive: viewModel.musicActivity != nil,
            onToggle: { viewModel.toggleActivity(.music) },
            expandedPreview: { MockMusicExpanded(state: .sample) },
            compactPreview: { MockMusicCompact() },
            minimalPreview: { MinimalIconView(systemImage: "music.note", color: .blue) }
        )
    }
    
    /// Chat activity section with message preview.
    private var chatSection: some View {
        ActivitySectionView(
            type: .chat,
            isActive: viewModel.chatActivity != nil,
            onToggle: { viewModel.toggleActivity(.chat) },
            expandedPreview: { MockChatExpanded(state: .sample) },
            compactPreview: { MockChatCompact() },
            minimalPreview: { MinimalDotView(color: .blue) }
        )
    }
    
    /// General progress activity section.
    private var generalSection: some View {
        ActivitySectionView(
            type: .general,
            isActive: viewModel.generalActivity != nil,
            onToggle: { viewModel.toggleActivity(.general) },
            expandedPreview: { MockGeneralExpanded(state: .sample) },
            compactPreview: { MockGeneralCompact(progress: GeneralActivityAttributes.ContentState.sample.progress) },
            minimalPreview: { MinimalIconView(systemImage: "timer", color: .blue) }
        )
    }
    
    /// View displayed when Live Activities are not supported.
    private var unsupportedDeviceView: some View {
        VStack(spacing: 16) {
            Image(systemName: "bolt.slash.fill")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(Color.ui.textSecondary)
            
            Text("Live Activities are not available on this device.")
                .font(.ui.bodyRegular)
                .foregroundStyle(Color.ui.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ui.secondaryBg.ignoresSafeArea())
    }
}

// MARK: - Activity Preview Mode
/// Defines the display modes for Live Activity previews.
enum ActivityPreviewMode: String, CaseIterable {
    case expanded = "Expanded"
    case compact = "Compact"
    case minimal = "Minimal"
}

// MARK: - Activity Section View
/// Reusable section component for displaying an activity type with controls and previews.
struct ActivitySectionView<Expanded: View, Compact: View, Minimal: View>: View {
    let type: LiveActivityType
    let isActive: Bool
    let onToggle: () -> Void
    @ViewBuilder let expandedPreview: () -> Expanded
    @ViewBuilder let compactPreview: () -> Compact
    @ViewBuilder let minimalPreview: () -> Minimal
    
    @State private var previewMode: ActivityPreviewMode = .expanded
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerRow
            previewModePicker
            previewContainer
        }
    }
    
    // MARK: - Subviews
    
    /// Header row with activity type label, status, and toggle button.
    private var headerRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(type.rawValue.uppercased())
                    .font(.caption.bold())
                    .foregroundColor(.blue)
                
                Text(isActive ? "Active Session" : "Ready to Launch")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            toggleButton
        }
    }
    
    /// Start/Stop toggle button with appropriate styling.
    private var toggleButton: some View {
        Button(action: onToggle) {
            Text(isActive ? "STOP" : "START")
                .font(.caption.bold())
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(buttonBackground)
                .foregroundColor(isActive ? .red : .blue)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isActive ? Color.red.opacity(0.3) : Color.blue.opacity(0.3))
                )
        }
    }
    
    /// Background color for the toggle button.
    private var buttonBackground: Color {
        isActive ? Color.red.opacity(0.1) : Color.blue.opacity(0.1)
    }
    
    /// Segmented picker for switching between preview modes.
    private var previewModePicker: some View {
        Picker("Preview Mode", selection: $previewMode) {
            ForEach(ActivityPreviewMode.allCases, id: \.self) { mode in
                Text(mode.rawValue).tag(mode)
            }
        }
        .pickerStyle(.segmented)
    }
    
    /// Container showing the selected preview mode.
    private var previewContainer: some View {
        ZStack {
            Color.black
            currentPreview
        }
        .frame(height: previewMode == .expanded ? 160 : 80)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(borderColor, lineWidth: 1.5)
        )
    }
    
    /// Current preview based on selected mode.
    @ViewBuilder
    private var currentPreview: some View {
        switch previewMode {
        case .expanded:
            expandedPreview()
        case .compact:
            compactPreview()
        case .minimal:
            minimalPreview()
        }
    }
    
    /// Border color based on activity state.
    private var borderColor: Color {
        isActive ? Color.blue.opacity(0.4) : Color.white.opacity(0.1)
    }
}

// MARK: - Minimal Preview Components
/// Minimal view showing an SF Symbol icon.
struct MinimalIconView: View {
    var emoji: String?
    var systemImage: String?
    var color: Color = .white
    
    var body: some View {
        Group {
            if let emoji {
                Text(emoji)
            } else if let systemImage {
                Image(systemName: systemImage)
                    .foregroundColor(color)
            }
        }
        .frame(width: 38, height: 38)
        .background(Color.black)
        .clipShape(Circle())
    }
}

/// Minimal view showing a colored dot indicator.
struct MinimalDotView: View {
    let color: Color
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 38, height: 38)
            .background(Color.black)
            .clipShape(Circle())
    }
}

// MARK: - Mock Expanded Previews
/// Expanded preview for football activity showing full match details.
struct MockFootballExpanded: View {
    let state: FootballActivityAttributes.ContentState
    
    var body: some View {
        VStack {
            HStack {
                Text(state.homeTeam.prefix(3).uppercased())
                    .font(.caption.bold())
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(state.scoreDisplay)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(state.awayTeam.prefix(3).uppercased())
                    .font(.caption.bold())
                    .foregroundColor(.white)
            }
            
            Text(state.formattedGameTime)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 8)
        }
        .padding(20)
    }
}

/// Compact preview for football activity showing just the score.
struct MockFootballCompact: View {
    let state: FootballActivityAttributes.ContentState
    
    var body: some View {
        HStack {
            Text("\(state.homeScore)")
                .padding(.leading, 12)
            Spacer()
            Text("\(state.awayScore)")
                .padding(.trailing, 12)
        }
        .foregroundColor(.white)
        .frame(width: 120, height: 38)
        .background(Color.black)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.gray.opacity(0.3)))
    }
}

/// Expanded preview for music activity showing track info and progress.
struct MockMusicExpanded: View {
    let state: MusicActivityAttributes.ContentState
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "music.note")
                    .foregroundColor(.blue)
                Spacer()
                Image(systemName: "waveform")
                    .foregroundColor(.blue)
            }
            
            VStack {
                Text(state.songName)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                
                Text(state.artist)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                ProgressView(value: state.progress)
                    .tint(.blue)
                    .padding(.top, 4)
            }
            .padding(.top, 8)
        }
        .padding(20)
    }
}

/// Compact preview for music activity showing playback controls.
struct MockMusicCompact: View {
    var body: some View {
        HStack {
            Image(systemName: "play.fill")
                .foregroundColor(.blue)
                .padding(.leading, 12)
            Spacer()
            Image(systemName: "waveform")
                .foregroundColor(.blue)
                .padding(.trailing, 12)
        }
        .frame(width: 120, height: 38)
        .background(Color.black)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.gray.opacity(0.3)))
    }
}

/// Expanded preview for chat activity showing sender and message.
struct MockChatExpanded: View {
    let state: ChatActivityAttributes.ContentState
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Circle()
                    .fill(.blue)
                    .frame(width: 24, height: 24)
                Spacer()
                Text("Now")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            Text(state.senderName)
                .font(.subheadline.bold())
                .foregroundColor(.white)
                .padding(.top, 4)
            
            Text(state.lastMessage)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
        }
        .padding(20)
    }
}

/// Compact preview for chat activity showing notification indicator.
struct MockChatCompact: View {
    var body: some View {
        HStack {
            Circle()
                .fill(.blue)
                .frame(width: 12, height: 12)
                .padding(.leading, 12)
            Spacer()
            Text("msg")
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(.trailing, 12)
        }
        .frame(width: 120, height: 38)
        .background(Color.black)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.gray.opacity(0.3)))
    }
}

/// Expanded preview for general activity showing title and progress.
struct MockGeneralExpanded: View {
    let state: GeneralActivityAttributes.ContentState
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "timer")
                    .foregroundColor(.blue)
                Spacer()
                Text(state.progressPercentage)
                    .font(.caption.bold())
                    .foregroundColor(.white)
            }
            
            VStack {
                Text(state.title)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                
                ProgressView(value: state.progress)
                    .tint(.blue)
                    .padding(.top, 4)
            }
            .padding(.top, 8)
        }
        .padding(20)
    }
}

/// Compact preview for general activity showing progress indicator.
struct MockGeneralCompact: View {
    let progress: Double
    
    var body: some View {
        HStack {
            Image(systemName: "timer")
                .padding(.leading, 12)
            Spacer()
            Text("\(Int(progress * 100))%")
                .font(.caption2)
                .padding(.trailing, 12)
        }
        .frame(width: 120, height: 38)
        .background(Color.black)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.gray.opacity(0.3)))
    }
}
