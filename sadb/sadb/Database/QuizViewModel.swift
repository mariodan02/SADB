import Foundation
import FirebaseCore
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseAuth

class QuizViewModel: ObservableObject {
    @Published var cigarettesPerDay: Double = 0
    @Published var packCost: Double = 0.0
    @Published var reasonToQuit: String = ""
    
    func pushNewValue(cigarettesPerDay: Double, packCost: Double, reasonToQuit: String, completion: @escaping () -> Void) {
        // Salva i dati nel modello o nel database
        self.cigarettesPerDay = cigarettesPerDay
        self.packCost = packCost
        self.reasonToQuit = reasonToQuit
        
        // Salvataggio in UserDefaults per semplicità di esempio
        UserDefaults.standard.set(cigarettesPerDay, forKey: "cigarettesPerDay")
        UserDefaults.standard.set(packCost, forKey: "packCost")
        UserDefaults.standard.set(reasonToQuit, forKey: "reasonToQuit")
        
        // Chiama la closure di completamento dopo il salvataggio
        completion()
    }
    
    func fetchQuizData(completion: @escaping (Double?, Double?) -> Void) {
        // Recupera i dati dal modello o dal database
        let cigarettesPerDay = UserDefaults.standard.double(forKey: "cigarettesPerDay")
        let packCost = UserDefaults.standard.double(forKey: "packCost")
        
        print("fetchQuizData: cigarettesPerDay = \(cigarettesPerDay), packCost = \(packCost)")
        
        completion(cigarettesPerDay != 0 ? cigarettesPerDay : nil, packCost != 0 ? packCost : nil)
    }
}
