import SwiftUI
import Combine
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

class MainViewModel: ObservableObject {
    @Published var moneySaved: Double = 0.0
    @Published var daysWithoutSmoking: Int = 0
    
    private var diaryViewModel = DiaryViewModel()
    private var quizViewModel = QuizViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchAllData()
    }
    
    private func fetchAllData() {
        fetchLastSmokingDate()
        fetchQuizData()
    }
    
    private func fetchLastSmokingDate() {
        diaryViewModel.fetchLastSmokingDate { [weak self] lastSmokingDate in
            guard let self = self, let lastSmokingDate = lastSmokingDate else { return }
            let daysWithoutSmoking = Calendar.current.dateComponents([.day], from: lastSmokingDate, to: Date()).day ?? 0
            DispatchQueue.main.async {
                self.daysWithoutSmoking = daysWithoutSmoking
            }
        }
    }
    
    private func fetchQuizData() {
        quizViewModel.fetchQuizData { [weak self] packCost, cigarettesPerDay in
            guard let self = self, let packCost = packCost, let cigarettesPerDay = cigarettesPerDay else { return }
            let moneySaved = self.calculateMoneySaved(packCost: packCost, cigarettesPerDay: Double(cigarettesPerDay))
            DispatchQueue.main.async {
                self.moneySaved = moneySaved
            }
        }
    }
    
    private func calculateMoneySaved(packCost: Double, cigarettesPerDay: Double) -> Double {
        let costPerCigarette = packCost / 20.0
        let daysWithoutSmoking = Double(self.daysWithoutSmoking)
        return costPerCigarette * cigarettesPerDay * daysWithoutSmoking
    }
}
