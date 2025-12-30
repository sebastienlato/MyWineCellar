//
//  AppShellView.swift
//  MyWineCellar
//
//  Created by Sebastien Lato on 2025-12-29.
//

import SwiftUI

struct AppShellView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem { Label("Home", systemImage: "house.fill") }

            NavigationStack {
                LibraryView()
            }
            .tabItem { Label("Library", systemImage: "books.vertical.fill") }

            NavigationStack {
                AddWineView()
            }
            .tabItem { Label("Add", systemImage: "plus.circle.fill") }

            NavigationStack {
                StatsView()
            }
            .tabItem { Label("Stats", systemImage: "chart.bar.fill") }
        }
        .tint(Theme.Colors.wine)
    }
}

#Preview {
    AppShellView()
}
