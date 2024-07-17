import Foundation
import Firebase
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseAuth

class AutenticationModel: ObservableObject {
    private let ref = Database.database().reference()
    
    func pushNewValue(value: String) {
        print("Hello world")
        ref.child("any Name").setValue(value)
    }
    
    func checkUsernameExists(username: String, completion: @escaping (Bool) -> Void) {
        let usernameRef = ref.child("username")
        usernameRef.queryOrdered(byChild: "name").queryEqual(toValue: username).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func pushNewUsername(username: String, completion: @escaping (Error?) -> Void) {
        let newUsernameRef = ref.child("username").childByAutoId()
        let usernameData: [String: Any] = ["name": username]
        newUsernameRef.setValue(usernameData) { error, _ in
            completion(error)
        }
    }
    
    func registerUser(email: String, password: String, username: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
                return
            }
            
            // Store username in the database
            self.pushNewUsername(username: username) { error in
                completion(error)
            }
        }
    }
}
