//
//  AppShellView.swift
//  MyWineCellar
//
//  Created by Sebastien Lato on 2025-12-29.
//

import SwiftUI

struct AppShellView: View {
    @StateObject private var appState = AppState()

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem { Label("Home", systemImage: "house.fill") }
            .tag(AppTab.home)

            NavigationStack {
                LibraryView()
            }
            .tabItem { Label("Library", systemImage: "books.vertical.fill") }
            .tag(AppTab.library)

            NavigationStack {
                AddWineView()
            }
            .tabItem { Label("Add", systemImage: "plus.circle.fill") }
            .tag(AppTab.add)

            NavigationStack {
                StatsView()
            }
            .tabItem { Label("Stats", systemImage: "chart.bar.fill") }
            .tag(AppTab.stats)
        }
        .tint(Theme.Colors.wine)
        .environmentObject(appState)
    }
}

#Preview {
    AppShellView()
}
