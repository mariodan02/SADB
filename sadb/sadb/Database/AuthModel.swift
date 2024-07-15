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
    
    func checkNicknameExists(nickname: String, completion: @escaping (Bool) -> Void) {
           // Crea un riferimento al nodo "nickname"
           let nicknameRef = ref.child("nickname")
           
           // Esegue una query per cercare il nickname specifico
           nicknameRef.queryOrdered(byChild: "name").queryEqual(toValue: nickname).observeSingleEvent(of: .value) { snapshot in
               if snapshot.exists() {
                   completion(true) // Il nickname esiste
               } else {
                   completion(false) // Il nickname non esiste
               }
           }
       }
    
    func pushNewNickname(nickname: String) {
        // Crea un nuovo riferimento sotto "nickname" con una chiave univoca
        let newNicknameRef = ref.child("nickname").childByAutoId()
        
        // Imposta i valori per il nuovo oggetto
        let nicknameData: [String: Any] = ["name": nickname]
        
        // Scrive i dati nel database
        newNicknameRef.setValue(nicknameData) { error, _ in
            if let error = error {
                print("Errore durante la scrittura dei dati: \(error.localizedDescription)")
            } else {
                print("Dati scritti correttamente nel database")
            }
        }
    }
        
}
