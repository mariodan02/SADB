import SwiftUI
import Charts

struct ProgressView: View {
    
    @AppStorage("e_mail") private var e_mail : String = ""
    @StateObject private var authModel = AuthModel()
    @StateObject private var viewModel = QuizViewModel()
    @State private var username: String?
    @State private var packCost: Double?
    @State private var cigarettesPerDay: Double?
    @State private var currentCigarettesPerDay: Double? = 10
    @State private var daysWithoutSmoking: Int = 0
    @State private var smokingDiary: [SmokingRecord] = []

    var body: some View {
        
        NavigationStack {
            ScrollView{
            VStack {
                if let username = username {
                    Text("Ciao, \(username)")
                        .padding(.top, 20)
                } else {
                    Text("Utente non loggato")
                        .onAppear {
                            authModel.fetchUsername { fetchedUsername in
                                self.username = fetchedUsername
                            }
                        }
                        .padding(.top, 20)
                }
                HStack {
                    VStack {
                        Image(systemName: "eurosign")
                            .font(.largeTitle)
                        Text(String(format: "%.2f", calculateMoneySaved()))
                            .font(.system(size: 50))
                        Text("Denaro risparmiato")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Image(systemName: "clock")
                            .font(.largeTitle)
                        Text("\(daysWithoutSmoking)")
                            .font(.system(size: 50))
                        Text("Giorni senza fumare")
                            .font(.caption)
                    }
                }
                .padding(.horizontal, 60)
                .padding(.top, 20)
                
                // Grafico a barre
                VStack {
                    Text("Nell'ultima settimana...")
                        .font(.headline)
                        .padding(.top, 20)
                    WeeklyCigaretteChartView()
                        .frame(height: 300)
                }
                .padding([.top, .horizontal], 20)
                
                // Bottoni
                VStack(spacing: 15) {
                    NavigationLink(destination: GoalsView(moneySaved: calculateMoneySaved(), daysWithoutSmoking: calculateDaysWithoutSmoking())){
                        Text("Obiettivi raggiunti")
                            .foregroundColor(.black)
                            .frame(maxWidth: 200)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: WishListView(packCost: packCost)) {
                        Text("Wishlist")
                            .foregroundColor(.black)
                            .frame(maxWidth: 200)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: HealthView(initialCigarettesPerDay: cigarettesPerDay, currentCigarettesPerDay: currentCigarettesPerDay)) {
                        Text("Salute")
                            .foregroundColor(.black)
                            .frame(maxWidth: 200)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                .padding([.top, .horizontal], 20)
                
                Spacer()
            }
            .background(Color.green.opacity(0.1))
            .navigationTitle("Progressi")
            .navigationBarTitleDisplayMode(.large)
        }
        }
        .onAppear {
            viewModel.fetchQuizData { (fetchedPackCost, fetchedCigarettesPerDay) in
                self.packCost = fetchedPackCost
                self.cigarettesPerDay = fetchedCigarettesPerDay
                fetchSmokingDiary()
                self.daysWithoutSmoking = calculateDaysWithoutSmoking()
            }
        }
    }
    
    private func calculateMoneySaved() -> Double {
        guard let packCost = packCost, let cigarettesPerDay = cigarettesPerDay, let currentCigarettesPerDay = currentCigarettesPerDay else {
            return 0.0
        }
        
        let cigarettesPerPack = 20.0
        let dailyCostInitial = (cigarettesPerDay / cigarettesPerPack) * packCost
        let dailyCostCurrent = (currentCigarettesPerDay / cigarettesPerPack) * packCost
        let dailySavings = dailyCostInitial - dailyCostCurrent
        let totalSaved = dailySavings * Double(daysWithoutSmoking)
        
        
        //per provare il metodo
//        let cigarettesPerPack = 20.0
//        let dailyCostInitial = (20 / cigarettesPerPack) * 5
//        let dailyCostCurrent = (10 / cigarettesPerPack) * 5
//        let dailySavings = dailyCostInitial - dailyCostCurrent
//        let totalSaved = dailySavings * Double(10)
        
        return totalSaved
    }
    
    //esempio di metodo che serve per provare i giorni senza fumare
    //sostituire con il metodo per prendere giorno-sigarette fumate dal db
    private func fetchSmokingDiary() {
           self.smokingDiary = [
               SmokingRecord(date: Date(), cigarettesSmoked: 0),
               SmokingRecord(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, cigarettesSmoked: 0),
               SmokingRecord(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, cigarettesSmoked: 5),
               SmokingRecord(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, cigarettesSmoked: 0)
           ]
       }
    
    private func calculateDaysWithoutSmoking() -> Int {
        var maxStreak = 0
        var currentStreak = 0
        
        for record in smokingDiary {
            if record.cigarettesSmoked == 0 {
                currentStreak += 1
                if currentStreak > maxStreak {
                    maxStreak = currentStreak
                }
            } else {
                currentStreak = 0
            }
        }
        
        return maxStreak
    }
    
    private func calculateTotalDaysWithoutSmoking() -> Int {
            return smokingDiary.filter { $0.cigarettesSmoked == 0 }.count
        }

}

struct SmokingRecord {
    let date: Date
    let cigarettesSmoked: Int
}

struct CigaretteData: Identifiable {
    var id = UUID()
    var day: String
    var cigarettes: Int
}

struct WeeklyCigaretteChartView: View {
    @State private var data: [CigaretteData] = [
        CigaretteData(day: "Lunedì", cigarettes: 10),
        CigaretteData(day: "Martedì", cigarettes: 12),
        CigaretteData(day: "Mercoledì", cigarettes: 8),
        CigaretteData(day: "Giovedì", cigarettes: 5),
        CigaretteData(day: "Venerdì", cigarettes: 7),
        CigaretteData(day: "Sabato", cigarettes: 14),
        CigaretteData(day: "Domenica", cigarettes: 9)
    ]
    
    var body: some View {
        Chart(data) { item in
            BarMark(
                x: .value("Day", item.day),
                y: .value("Cigarettes", item.cigarettes)
            )
            .foregroundStyle(Color.green)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .padding()
    }
}

struct WeeklyCigaretteChartView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyCigaretteChartView()
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}


