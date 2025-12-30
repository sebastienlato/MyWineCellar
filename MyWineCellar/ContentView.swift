//
//  ContentView.swift
//  MyWineCellar
//
//  Created by Sebastien Lato on 2025-12-29.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    var body: some View {
        AppShellView()
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.previewContainer())
}
