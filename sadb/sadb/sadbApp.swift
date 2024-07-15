//
//  sadbApp.swift
//  sadb
//
//  Created by Studente on 02/07/24.
//

import SwiftUI

@main
struct sadbApp: App {
    
    @AppStorage("hasCompletedQuiz") private var hasCompletedQuiz: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedQuiz {
                ContentView()
            } else {
                QuizView()
            }
        }
    }
    
}
