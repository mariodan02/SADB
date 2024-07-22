import SwiftUI
import Charts

// Define the SmokingRecord type
struct SmokingRecord {
    let date: Date
    let cigarettesSmoked: Int
}

// Define the WeeklyCigaretteChartView within the same file
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

struct ProgressView: View {
    
    @AppStorage("e_mail") private var e_mail : String = ""
    @AppStorage("installationDate") private var installationDateString: String?
    @StateObject private var authModel = AuthModel()
    @StateObject private var viewModel = QuizViewModel()
    @StateObject private var diaryModel = DiaryViewModel()
    @State private var username: String?
    @State private var packCost: Double?
    @State private var cigarettesPerDay: Double?
    @State private var daysWithoutSmoking: Int = 0
    @State private var smokingDiary: [SmokingRecord] = []
    @State private var lastSmokingDate: Date?

    var body: some View {
        NavigationStack {
            ScrollView {
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
                        NavigationLink(destination: GoalsView(moneySaved: calculateMoneySaved(), daysWithoutSmoking: daysWithoutSmoking)){
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
                        
                        NavigationLink(destination: HealthView()) {
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
            }
            .background(Color.green.opacity(0.1))
            .navigationTitle("Progressi")
        }
        .onAppear {
            // Store the installation date if it doesn't exist
            if installationDateString == nil {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                installationDateString = formatter.string(from: Date())
            }

            viewModel.fetchQuizData { (fetchedCigarettesPerDay, fetchedPackCost) in
                print("Fetched PackCost: \(String(describing: fetchedPackCost)), Fetched CigarettesPerDay: \(String(describing: fetchedCigarettesPerDay))")
                self.packCost = fetchedPackCost
                self.cigarettesPerDay = fetchedCigarettesPerDay
                diaryModel.fetchLastSmokingDate { date in
                    if let date = date {
                        self.lastSmokingDate = date
                    } else if let installationDateString = installationDateString {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        self.lastSmokingDate = formatter.date(from: installationDateString)
                    }
                    self.daysWithoutSmoking = self.calculateDaysWithoutSmoking()
                }
                print("PackCost after assignment: \(String(describing: self.packCost)), CigarettesPerDay after assignment: \(String(describing: self.cigarettesPerDay))")
            }
        }
    }
    
    private func calculateMoneySaved() -> Double {
        guard let packCost = packCost, let cigarettesPerDay = cigarettesPerDay else {
            return 0.0
        }
        
        let cigarettesPerPack = 20.0
        let dailyCost = (cigarettesPerDay / cigarettesPerPack) * packCost
        let totalSaved = dailyCost * Double(daysWithoutSmoking)
        
        return totalSaved
    }
    
    private func calculateDaysWithoutSmoking() -> Int {
        guard let lastSmokingDate = lastSmokingDate else {
            return 0
        }
        let days = Calendar.current.dateComponents([.day], from: lastSmokingDate, to: Date()).day ?? 0
        return days
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
