import Foundation
import Firebase
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseAuth

class AuthModel: ObservableObject {
    private let ref = Database.database(url: "https://sadb-90c67-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.debug)
    }
    
    func pushNewValue(username: String, email: String, password: String, completion: @escaping (Error?) -> Void) {
        checkUsernameExists(username: username) { exists in
            if exists {
                print("Username already exists.")
                completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Username already exists"]))
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Error creating user: \(error.localizedDescription)")
                    completion(error)
                    return
                }
                guard let uid = authResult?.user.uid else {
                    completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User UID not found"]))
                    return
                }
                // Store the username in the database with the UID as the key
                self.pushNewUsername(uid: uid, username: username) { error in
                    if let error = error {
                        print("Error pushing new username: \(error.localizedDescription)")
                    }
                    completion(error)
                }
            }
        }
    }

    func login(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }
    
    func checkUsernameExists(username: String, completion: @escaping (Bool) -> Void) {
        let usernameRef = ref.child("usernames")
        usernameRef.queryOrdered(byChild: "name").queryEqual(toValue: username).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        } withCancel: { error in
            print("Error checking username existence: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func pushNewUsername(uid: String, username: String, completion: @escaping (Error?) -> Void) {
        let newUsernameRef = ref.child("usernames").child(uid)
        let usernameData: [String: Any] = ["name": username]
        newUsernameRef.setValue(usernameData) { error, _ in
            if let error = error {
                print("Error pushing new username: \(error.localizedDescription)")
            }
            completion(error)
        }
    }
}

