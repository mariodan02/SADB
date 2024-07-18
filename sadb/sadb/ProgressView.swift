import SwiftUI
import Charts


struct ProgressView: View {
    
    @AppStorage("e_mail") private var e_mail : String = ""
    @StateObject private var authModel = AuthModel()
    @State private var username: String?

    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack {
                    if let username = username {
                        Text("Ciao, \(username)")
                            .padding(.top, 20)
                    } else {
                        Text("Utente non loggato")
                            .padding(.top, 20)
                            .onAppear {
                                authModel.fetchUsername { fetchedUsername in
                                    self.username = fetchedUsername
                                }
                            }
                    }
                    HStack {
                        VStack {
                            Image(systemName: "eurosign")
                                .font(.largeTitle)
                            Text(String(format: "%.2f", 0))
                                .font(.system(size: 50))
                            Text("Denaro risparmiato")
                                .font(.caption)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Image(systemName: "clock")
                                .font(.largeTitle)
                            Text("0")
                                .font(.system(size: 50))
                            Text("Giorni senza fumare")
                                .font(.caption)
                        }
                    }
                    .padding(.horizontal, 60)
                    .padding(.top, 40)
                    
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
                        NavigationLink(destination: GoalsView()){
                            Text("Obiettivi raggiunti")
                                .foregroundColor(.black)
                                .frame(maxWidth: 200)
                                .padding()
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(10)
                        }
                        
                        NavigationLink(destination: WishListView()) {
                            Text("Wishlist")
                                .foregroundColor(.black)
                                .frame(maxWidth: 200)
                                .padding()
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(10)
                        }
                        
                        NavigationLink(destination: HealthView()) {
                            Text("Salute")
                                .foregroundColor(.black)
                                .frame(maxWidth: 200)
                                .padding()
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    .padding([.top, .horizontal], 20)
                    
                    Spacer()
                }
            }
            .background(Color.green.opacity(0.1))
            .navigationTitle("Progressi")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationBarBackButtonHidden()
        // .onAppear(perform: loadData)
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
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

