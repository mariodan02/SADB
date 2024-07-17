import Foundation
import FirebaseCore
import FirebaseDatabase
import FirebaseDatabaseSwift

class QuizViewModel: ObservableObject {
    private let ref = Database.database().reference()
    
    func pushNewValue(cigarettesPerDay: Double, packCost: Double, reasonToQuit: String) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            print("Username not found in UserDefaults")
            return
        }
        
        let quizData = [
            "cigarettesPerDay": cigarettesPerDay,
            "packCost": packCost,
            "reasonToQuit": reasonToQuit,
            "timestamp": Date().timeIntervalSince1970
        ] as [String : Any]
        
        ref.child("username").child(username).childByAutoId().setValue(quizData)
    }
}
