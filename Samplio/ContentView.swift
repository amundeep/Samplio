//
//  ContentView.swift
//  SoundPad
//
//  Created by Amundeep Singh on 10/7/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationStack {
            PadGridView()
        }
    }
}

#Preview {
    NavigationStack { PadGridView() }
}
