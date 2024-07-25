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

    func pushNewValue(wishName: String, wishCost: Double, imageData: Data?) {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated")
            return
        }

        var wishData: [String: Any] = [
            "cost": wishCost
        ]

        if let imageData = imageData {
            let base64String = imageData.base64EncodedString()
            wishData["image"] = base64String
        }

        ref.child("usernames").child(user.uid).child("wishList").child(wishName).setValue(wishData) { error, _ in
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
                   let wishData = snapshot.value as? [String: Any],
                   let wishCost = wishData["cost"] as? Double {
                    let wishName = snapshot.key
                    let equivalentPacks = self.packCost != nil ? Int(wishCost / self.packCost!) : 0
                    let equivalentText = "\(equivalentPacks) pacchetti di sigarette"
                    
                    var image: Image
                    if let base64String = wishData["image"] as? String,
                       let imageData = Data(base64Encoded: base64String),
                       let uiImage = UIImage(data: imageData) {
                        image = Image(uiImage: uiImage)
                    } else {
                        image = Image("gift")
                    }
                    
                    let newItem = WishItem(
                        name: wishName,
                        cost: "\(wishCost)€",
                        equivalent: equivalentText,
                        isActive: true,
                        image: image
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
