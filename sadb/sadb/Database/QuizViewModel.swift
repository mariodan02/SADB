import Foundation
import FirebaseCore
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseAuth

class QuizViewModel: ObservableObject {
    private let ref = Database.database(url: "https://sadb-90c67-default-rtdb.europe-west1.firebasedatabase.app").reference()

    func pushNewValue(cigarettesPerDay: Double, packCost: Double, reasonToQuit: String) {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated")
            return
        }

        // Retrieve the username based on the authenticated user's UID
        ref.child("usernames").child(user.uid).observeSingleEvent(of: .value) { snapshot in
            if let usernameDict = snapshot.value as? [String: Any],
               let username = usernameDict["name"] as? String {
                let quizData = [
                    "cigarettesPerDay": cigarettesPerDay,
                    "packCost": packCost,
                    "reasonToQuit": reasonToQuit,
                    "timestamp": Date().timeIntervalSince1970,
                ] as [String: Any]

                // Store the quiz data directly under the username node
                self.ref.child("usernames").child(user.uid).child("quizData").setValue(quizData) { error, _ in
                    if let error = error {
                        print("Error pushing quiz data: \(error.localizedDescription)")
                    } else {
                        print("Quiz data successfully pushed")
                    }
                }
            } else {
                print("Username not found for the current user.")
            }
        }
    }

    func checkQuizCompletion(completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated")
            completion(false)
            return
        }

        ref.child("usernames").child(user.uid).child("quizData").observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
