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

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
