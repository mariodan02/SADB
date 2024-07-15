import Foundation
import Firebase
import FirebaseDatabase
import FirebaseDatabaseSwift

class AutenticationModel: ObservableObject{
    //in ref ci troviamo la root del mio db
    private let ref = Database.database().reference()
    
    func pushNewValue(value: String){
        print("Hello world")
        ref.child("any Name").setValue(value)
    }
    
    func checkUsernameExists(username: String, completion: @escaping (Bool) -> Void) {
           // Crea un riferimento al nodo "username"
           let usernameRef = ref.child("username")
           
           // Esegue una query per cercare il username specifico
            usernameRef.queryOrdered(byChild: "name").queryEqual(toValue: username).observeSingleEvent(of: .value) { snapshot in
               if snapshot.exists() {
                   completion(true) // Il username esiste
               } else {
                   completion(false) // Il username non esiste
               }
           }
       }
    
    func pushNewUsername(username: String) {
        // Crea un nuovo riferimento sotto "nickname" con una chiave univoca
        let newUsernameRef = ref.child("username").childByAutoId()
        
        // Imposta i valori per il nuovo oggetto
        let usernameData: [String: Any] = ["name": username]
        
        // Scrive i dati nel database
        newUsernameRef.setValue(usernameData) { error, _ in
            if let error = error {
                print("Errore durante la scrittura dei dati: \(error.localizedDescription)")
            } else {
                print("Dati scritti correttamente nel database")
            }
        }
    }
        
}
