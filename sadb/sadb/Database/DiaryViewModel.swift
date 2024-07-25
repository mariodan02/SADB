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
            ref.child("usernames").child(user.uid).child("diaryData").child(dateString).observeSingleEvent(of: .value) { snapshot in
                var updatedCigSmokedToday = cigSmokedToday
                
                // Se esiste già una voce per questa data, somma i valori
                if let existingValue = snapshot.value as? Int {
                    updatedCigSmokedToday += existingValue
                }
                
                // Aggiorna il valore nel database
                self.ref.child("usernames").child(user.uid).child("diaryData").child(dateString).setValue(updatedCigSmokedToday) { error, _ in
                    if let error = error {
                        print("Error updating diary data: \(error.localizedDescription)")
                    } else {
                        print("Diary data successfully updated")
                    }
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

    func fetchSmokingDiary(completion: @escaping ([SmokingRecord]) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated")
            completion([])
            return
        }
        ref.child("usernames").child(user.uid).child("diaryData").observeSingleEvent(of: .value) { snapshot in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var records: [SmokingRecord] = []

            if let diaryData = snapshot.value as? [String: Any] {
                for (dateString, value) in diaryData {
                    if let date = dateFormatter.date(from: dateString), let cigarettesSmoked = value as? Int {
                        records.append(SmokingRecord(date: date, cigarettesSmoked: cigarettesSmoked))
                    }
                }
            }
            completion(records)
        }
    }

    func deleteDiaryEntry(for date: Date, cigarettesSmoked: Int, completion: @escaping (Bool) -> Void) {
            guard let user = Auth.auth().currentUser else {
                print("User not authenticated")
                completion(false)
                return
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)

            ref.child("usernames").child(user.uid).child("diaryData").child(dateString).observeSingleEvent(of: .value) { snapshot in
                if var existingValue = snapshot.value as? Int {
                    existingValue -= cigarettesSmoked
                    if existingValue <= 0 {
                        self.ref.child("usernames").child(user.uid).child("diaryData").child(dateString).removeValue { error, _ in
                            if let error = error {
                                print("Error deleting diary entry: \(error.localizedDescription)")
                                completion(false)
                            } else {
                                print("Diary entry successfully deleted")
                                completion(true)
                            }
                        }
                    } else {
                        self.ref.child("usernames").child(user.uid).child("diaryData").child(dateString).setValue(existingValue) { error, _ in
                            if let error = error {
                                print("Error updating diary data after deletion: \(error.localizedDescription)")
                                completion(false)
                            } else {
                                print("Diary data successfully updated after deletion")
                                completion(true)
                            }
                        }
                    }
                } else {
                    completion(false)
                }
            }
        }
}
