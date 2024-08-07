import Foundation
import Firebase
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseAuth

class AuthModel: ObservableObject {
    @Published var username: String?
    private let ref = Database.database(url: "https://sadb-90c67-default-rtdb.europe-west1.firebasedatabase.app").reference()

    func pushNewValue(username: String, email: String, password: String, completion: @escaping (Error?) -> Void) {
            checkUsernameExists(username: username) { exists in
                if exists {
                    print("Username already exists.")
                    completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Username già esistente"]))
                    return
                }
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        let nsError = error as NSError
                        if nsError.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                            // Email già utilizzata
                            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "L'email inserita è già associata ad un altro account."]))
                        } else {
                            // Altri errori
                            completion(error)
                        }
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
    
    func fetchUsername(completion: @escaping (String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        let usernameRef = ref.child("usernames").child(uid).child("name")
        usernameRef.observeSingleEvent(of: .value) { snapshot in
            if let username = snapshot.value as? String {
                self.username = username
                completion(username)
            } else {
                completion(nil)
            }
        } withCancel: { error in
            print("Error fetching username: \(error.localizedDescription)")
            completion(nil)
        }
    }
}
