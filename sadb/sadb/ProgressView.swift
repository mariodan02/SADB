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
    var data: [CigaretteData]

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
    @AppStorage("cigarettesSmokedDiary") private var cigarettesSmokedDiary: Int = 0
    @StateObject private var authModel = AuthModel()
    @StateObject private var viewModel = QuizViewModel()
    @StateObject private var diaryModel = DiaryViewModel()
    @State private var username: String?
    @State private var packCost: Double?
    @State private var cigarettesPerDay: Double?
    @State private var daysWithoutSmoking: Int = 0
    @State private var smokingDiary: [SmokingRecord] = []
    @State private var lastSmokingDate: Date?
    @State private var weeklySmokingData: [CigaretteData] = []

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
                        WeeklyCigaretteChartView(data: weeklySmokingData)
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
                diaryModel.fetchSmokingDiary { diary in
                    self.smokingDiary = diary
                    print("PackCost after assignment: \(String(describing: self.packCost)), CigarettesPerDay after assignment: \(String(describing: self.cigarettesPerDay))")
                }
            }
            fetchWeeklySmokingData()
        }
    }
    
    private func fetchWeeklySmokingData() {
        diaryModel.fetchSmokingDiary { records in
            let calendar = Calendar.current
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE" // To get day names

            let lastSevenDays = (0..<7).map {
                calendar.date(byAdding: .day, value: -$0, to: today)!
            }
            
            let filteredRecords = records.filter { record in
                lastSevenDays.contains { calendar.isDate(record.date, inSameDayAs: $0) }
            }

            var data: [CigaretteData] = []
            for date in lastSevenDays {
                let dayName = dateFormatter.string(from: date)
                let cigarettesSmoked = filteredRecords.first { calendar.isDate($0.date, inSameDayAs: date) }?.cigarettesSmoked ?? 0
                data.append(CigaretteData(day: dayName, cigarettes: cigarettesSmoked))
            }
            weeklySmokingData = data.reversed() // Reversing to show from earliest to latest
        }
    }
    
    private func calculateMoneySaved() -> Double {
        guard let packCost = packCost, let cigarettesPerDay = cigarettesPerDay else {
            return 0.0
        }
        
        let dailyCost = (cigarettesPerDay * packCost) / 20
        
        // Calculate total days since installation
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let installationDateString = installationDateString, let installationDate = formatter.date(from: installationDateString) else {
            return 0.0
        }
        let totalDays = Calendar.current.dateComponents([.day], from: installationDate, to: Date()).day ?? 0
        
        // Calculate total saved without smoking
        let totalSaved = dailyCost * Double(totalDays)
        
        // Calculate the cost of cigarettes smoked from the diary
        let aCigCost = packCost / 20
        let totalCostSmoked = Double(cigarettesSmokedDiary) * aCigCost
        
        return totalSaved - totalCostSmoked
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
        WeeklyCigaretteChartView(data: [
            CigaretteData(day: "Lunedì", cigarettes: 10),
            CigaretteData(day: "Martedì", cigarettes: 12),
            CigaretteData(day: "Mercoledì", cigarettes: 8),
            CigaretteData(day: "Giovedì", cigarettes: 5),
            CigaretteData(day: "Venerdì", cigarettes: 7),
            CigaretteData(day: "Sabato", cigarettes: 14),
            CigaretteData(day: "Domenica", cigarettes: 9)
        ])
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
