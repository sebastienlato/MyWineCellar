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
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }

            LibraryView()
                .tabItem { Label("Library", systemImage: "books.vertical.fill") }

            AddWineView()
                .tabItem { Label("Add", systemImage: "plus.circle.fill") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
        .tint(Theme.Colors.wine)
    }
}

// MARK: - Placeholder Tabs

private struct HomeView: View {
    var body: some View {
        ZStack(alignment: .top) {
            // Base background
            Theme.Colors.charcoal.ignoresSafeArea()

            // Hero background only for the header area
            ZStack {
                Image("HeroBlur")
                    .resizable()
                    .scaledToFill()

                LinearGradient(
                    colors: [
                        Theme.Colors.charcoal.opacity(0.55),
                        Theme.Colors.charcoal
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(height: 240)
            .clipped()
            .ignoresSafeArea(edges: .top)

            // Content (guaranteed safe padding)
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("MyWineCellar")
                        .font(.system(.largeTitle, design: .serif).weight(.semibold))
                        .foregroundStyle(Theme.Colors.textPrimary)

                    Text("Discover • Track • Review")
                        .foregroundStyle(Theme.Colors.textSecondary)
                }

                VStack(spacing: Theme.Spacing.md) {
                    StatCard(title: "Recent", subtitle: "Your latest tastings", systemImage: "clock.fill")
                    StatCard(title: "Wishlist", subtitle: "Wines you want to try", systemImage: "heart.fill")
                    StatCard(title: "Stats", subtitle: "Ratings & regions", systemImage: "chart.bar.fill")
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 24)
        }
    }
}


private struct LibraryView: View {
    var body: some View {
        ZStack {
            Theme.Colors.charcoal.ignoresSafeArea()
            Text("Library (coming next)")
                .foregroundStyle(Theme.Colors.textPrimary)
        }
    }
}

private struct AddWineView: View {
    var body: some View {
        ZStack {
            Theme.Colors.charcoal.ignoresSafeArea()
            Text("Add Wine (coming next)")
                .foregroundStyle(Theme.Colors.textPrimary)
        }
    }
}

private struct SettingsView: View {
    var body: some View {
        ZStack {
            Theme.Colors.charcoal.ignoresSafeArea()
            Text("Settings (coming next)")
                .foregroundStyle(Theme.Colors.textPrimary)
        }
    }
}

// MARK: - Small Component

private struct StatCard: View {
    let title: String
    let subtitle: String
    let systemImage: String

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(Theme.Colors.wine)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Theme.Colors.textPrimary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }

            Spacer()
        }
        .padding(Theme.Spacing.lg)
        .background(Theme.Colors.card)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.card)
                .stroke(Theme.Colors.divider.opacity(0.8), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card))
    }
}

#Preview {
    AppShellView()
}

