//
//  ContentView.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 11/13/25.
//

import SwiftUI
import BaseModule

struct HomeView: View {
    // MARK: - properties
    @Environment(AppState.self) private var appState
    @StateObject var viewModel: HomeViewModel
    @State var coordinator = Coordinator()
    @State var userHasIntroduction: Bool?
    @State var createIntroduction = false
    @State var taskId = "taskId"
    
    // MARK: - init
    init() {
        _viewModel = .init(wrappedValue: .init())
    }
    
    // MARK: - view
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            List {
                Section {
                    introductionView()
                } header: {
                    Text("Personal")
                        .foregroundStyle(.ui.black)
                        .font(.ui.largSemiBold)
                }
                
                Section {
                    NavigationLink {
                        LazyView {
                            CollapsableHeaderView()
                        }
                    } label: {
                        HomeItemView(title: "Collapsable header",
                                     description: "A test for collapsable header")
                    }
                    
                    NavigationLink {
                        LazyView {
                            LiveActivityView()
                        }
                    } label: {
                        HomeItemView(title: "Live Activity",
                                     description: "Widget Extension")
                    }
                } header: {
                    Text("Custom Views")
                        .foregroundStyle(.ui.black)
                        .font(.ui.largSemiBold)
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
        .onChange(of: createIntroduction, { oldValue, newValue in
            taskId = UUID().uuidString
        })
        .task(id: taskId){
            self.userHasIntroduction = await viewModel.userHasCompletedIntroduction()
        }
        .toast(toast: $viewModel.toast)
        .sheet(isPresented: $createIntroduction) {
            CreateUserIntroductionView()
        }
    }
    
    
    // MARK: - view fuctions
    @ViewBuilder
    fileprivate func introductionView() -> some View {
        if userHasIntroduction == true {
            NavigationLink {
                LazyView {
                    IntroductionView()
                }
            } label: {
                HomeItemView(title: "Intorduction",
                             description: "Show every one who R U?")
            }
        } else if userHasIntroduction == nil {
            HStack {
                Text("Checking your profile")
                Spacer()
                ProgressView()
                    .progressViewStyle(.circular)
            }
        } else {
            Button {
                createIntroduction = true
            } label: {
                Text("Add intro")
                    .leading()
            }
        }
    }
    
    // MARK: - functions
    func logout() {
        if viewModel.logout() {
            waitMainThread(after: 2) {
                appState.setFlow(.login)
            }
        }
    }
}


