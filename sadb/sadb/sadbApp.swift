import SwiftUI
import FirebaseCore

@main
struct sadbApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    //@AppStorage("hasCompletedQuiz") private var hasCompletedQuiz: Bool = false
    //@AppStorage("hasRegistered") private var hasRegistered: Bool = false
    @AppStorage("isLogged") private var isLogged: Bool = false
    @AppStorage("navigateToQuiz") private var navigateToQuiz = false
    
    var body: some Scene {
        WindowGroup {
            
            if (!isLogged){
                LoginView()
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
