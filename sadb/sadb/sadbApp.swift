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
    @AppStorage("hasRegistered") private var hasRegistered: Bool = false
    @AppStorage("isLogged") private var isLogged: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if !hasRegistered {
                     RegistrationView()
             } else if !isLogged {
                 LoginView()
             } else if !hasCompletedQuiz {
                 QuizView()
             } else {
                 ContentView()
             }
        }
    }
    
}
