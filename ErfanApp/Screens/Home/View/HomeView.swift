//
//  ContentView.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/13/25.
//

import SwiftUI
import BaseModule

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @StateObject var viewModel: HomeViewModel
    @State var coordinator = Coordinator()
    
    init() {
        _viewModel = .init(wrappedValue: .init())
    }
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            List {
                NavigationLink {
                    LazyView {
                        IntroductionView()
                    }
                } label: {
                    HomeItemView(title: "Intorduction",
                                 description: "Show every one who R U?")
                }
                NavigationLink {
                    LazyView {
                        CollapsableHeaderView()
                    }
                } label: {
                    HomeItemView(title: "Collapsable header",
                                 description: "A test for collapsable header")
                }
            }
            .navigationTitle("Home")
            .navigationBarItems(trailing: Button("Logout") {
                logout()
            })
        }
        .background {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
        }
        .toast(toast: $viewModel.toast)
    }
    
    func logout() {
        if viewModel.logout() {
            waitMainThread(after: 2) {
                appState.setFlow(.login)
            }
        }
    }
}
