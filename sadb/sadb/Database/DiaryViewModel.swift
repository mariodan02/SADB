import Foundation
import FirebaseCore
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseAuth

class DiaryViewModel: ObservableObject {
    private let ref = Database.database(url: "https://sadb-90c67-default-rtdb.europe-west1.firebasedatabase.app").reference()

    func pushNewValue(currentDate: Date, cigSmokedToday: Int) {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Customize the format as needed
        let dateString = dateFormatter.string(from: currentDate)

        // Recupera l'username basandosi sull'UID dell'user autenticato
        ref.child("usernames").child(user.uid).observeSingleEvent(of: .value) { snapshot in
            if let usernameDict = snapshot.value as? [String: Any],
               let username = usernameDict["name"] as? String {
                let diaryData = [
                    dateString: cigSmokedToday
                ]

                // Update the diaryData under the username node
                self.ref.child("usernames").child(user.uid).child("diaryData").updateChildValues(diaryData) { error, _ in
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
    
    func fetchLastSmokingDate(completion: @escaping (Date?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated")
            completion(nil)
            return
        }
        ref.child("usernames").child(user.uid).child("diaryData").observeSingleEvent(of: .value) { snapshot in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var latestDate: Date? = nil
            
            if let diaryData = snapshot.value as? [String: Any] {
                for (dateString, _) in diaryData {
                    if let date = dateFormatter.date(from: dateString), (latestDate == nil || date > latestDate!) {
                        latestDate = date
                    }
                }
            }
            completion(latestDate)
        }
    }
}
