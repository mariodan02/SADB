import SwiftUI
import FirebaseAuth
import FirebaseDatabase

class WishListViewModel: ObservableObject {
    
    let ref = Database.database(url: "https://sadb-90c67-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    @Published var wishList = [WishItem]()
    @Published var packCost: Double?
    
    init() {
        loadPackCost { [weak self] cost in
            guard let self = self else { return }
            if let cost = cost {
                self.packCost = cost
                print("Pack cost loaded: \(cost)")
                self.loadWishes() // Carica la lista dei desideri dopo aver caricato il packCost
            } else {
                print("Failed to load pack cost")
            }
        }
    }
    
    func loadPackCost(completion: @escaping (Double?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated")
            completion(nil)
            return
        }

        ref.child("usernames").child(user.uid).child("quizData").observeSingleEvent(of: .value) { snapshot in
            if let quizData = snapshot.value as? [String: Any],
               let packCost = quizData["packCost"] as? Double {
                completion(packCost)
            } else {
                completion(nil)
            }
        }
    }

    func pushNewValue(wishName: String, wishCost: Double) {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated")
            return
        }

        let wishData = [
            wishName: wishCost
        ]

        ref.child("usernames").child(user.uid).child("wishList").updateChildValues(wishData) { error, _ in
            if let error = error {
                print("Error pushing wish data: \(error.localizedDescription)")
            } else {
                print("Wish data successfully pushed")
                self.loadWishes() // Reload wishes after pushing new value
            }
        }
    }

    func loadWishes() {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated")
            return
        }

        ref.child("usernames").child(user.uid).child("wishList").observe(.value) { snapshot in
            var loadedWishes = [WishItem]()

            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let wishCost = snapshot.value as? Double,
                   let wishName = snapshot.key as? String {
                    
                    let equivalentPacks = self.packCost != nil ? Int(wishCost / self.packCost!) : 0
                    let equivalentText = "\(equivalentPacks) pacchetti di sigarette"
                    
                    let newItem = WishItem(
                        name: wishName,
                        cost: "\(wishCost)€",
                        equivalent: equivalentText,
                        isActive: true,
                        image: Image("gift")
                    )

                    loadedWishes.append(newItem)
                }
            }

            DispatchQueue.main.async {
                self.wishList = loadedWishes
            }
        }
    }
}
