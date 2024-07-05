//
//  ContentView.swift
//  sadb
//
//  Created by Studente on 02/07/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            progressView()
                .tabItem {
                    Label("Progressi", systemImage: "sparkles")
                }
            
            myTreeView()
                .tabItem {
                    Label("Il mio albero", systemImage: "leaf")
                }
            
            diaryView()
                .tabItem {
                    Label("Diario", systemImage: "list.bullet")
                }
        }
        .accentColor(.green)
    }
}

#Preview {
    ContentView()
}
