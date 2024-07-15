//
//  sadbApp.swift
//  sadb
//
//  Created by Studente on 02/07/24.
//

import SwiftUI
import FirebaseCore

@main
struct sadbApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
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

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
