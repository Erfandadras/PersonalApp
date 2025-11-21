//
//  LanguageSettingsView.swift
//  BaseModule
//
//  Created by Erfan mac mini on 11/20/25.
//

import SwiftUI

/// Example view demonstrating language switching functionality
public struct LanguageSettingsView: View {
    @EnvironmentObject var localizationManager: LocalizationManager

    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(localizationManager.currentLanguage.displayName)
                .font(.ui.mSemiBold)
                .foregroundColor(.ui.textPrimary)
                .padding(.leading, 20)
            List {
                Section {
                    ForEach(AppLanguage.allCases, id: \.self) { language in
                        Button {
                            localizationManager.setLanguage(language)
                        } label: {
                            HStack {
                                Text(language.displayName)
                                    .foregroundColor(.ui.textPrimary)
                                Spacer()
                                if localizationManager.currentLanguage == language {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                } header: {
                    HStack {
                        Text(L.Language.language)
                    }
                }
                
                Section {
                    HStack {
                        Text("Current Direction")
                        Spacer()
                        Text(localizationManager.isRTL ? "RTL (→)" : "LTR (←)")
                            .foregroundColor(.ui.textSecondary)
                            .preventListMirroring()
                    }
                    
                    Button {
                        localizationManager.toggleLanguage()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left.arrow.right")
                            Text(L.Language.changeLanguage)
                        }
                    }
                } header: {
                    Text("Quick Actions")
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(L.Common.welcome)
                        Text(L.Common.hello)
                            .font(.subheadline)
                            .foregroundColor(.ui.textSecondary)
                    }
                } header: {
                    Text("Preview")
                }
            }
        }
        .animation(.default, value: localizationManager.currentLanguage)
        .navigationTitle(L.Language.language)
    }
}

//#Preview("English") {
//    NavigationView {
//        LanguageSettingsView()
//            .environmentObject({
//                let manager = LocalizationManager(userManager: .init())
//                return manager
//            }())
//    }
//    .environment(\.locale, .init(identifier: "en"))
//}
//
