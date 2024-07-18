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
    
    //@AppStorage("hasCompletedQuiz") private var hasCompletedQuiz: Bool = false
    //@AppStorage("hasRegistered") private var hasRegistered: Bool = false
    @AppStorage("isLogged") private var isLogged: Bool = false
    
    var body: some Scene {
        WindowGroup {
<<<<<<< HEAD
            
            if (!isLogged){
                LoginView()
            } else {
                ContentView()
            }
            
=======
            DiaryView()
>>>>>>> ff8acc1be219510e95545b2d00acd6cd4bbbcce6
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

