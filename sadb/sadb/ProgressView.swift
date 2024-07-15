import SwiftUI

struct ProgressView: View {
    @State private var cigarettesPerDay: Double = 0
    @State private var packCost: Double = 0
    @State private var cigarettesSmokedDiary: Double = 0
    @State private var installationDateTimestamp: Double = Date().timeIntervalSince1970
    
    var moneySaved: Double {
        let cigCost = packCost / cigarettesPerDay
        return cigCost * cigarettesPerDay - cigCost * cigarettesSmokedDiary
    }
    
    var daysWithoutSmoking: Int {
        let daysSinceInstallation = Date().timeIntervalSince1970 - installationDateTimestamp
        return Int(daysSinceInstallation / 86400.0)
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Denaro risparmiato e giorni senza fumare
                HStack {
                    VStack {
                        Image(systemName: "eurosign")
                            .font(.largeTitle)
                        Text(String(format: "%.2f", moneySaved))
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
                .padding(.top, 40)
                
                // Grafico
                VStack {
                    Image(systemName: "chart.pie")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    Text("Grafico")
                        .font(.headline)
                }
                .padding(.top, 20)
                
                // Bottoni
                VStack(spacing: 15) {
                    NavigationLink(destination: GoalsView()) {
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
            .background(Color.green.opacity(0.1))
            .navigationTitle("Progressi")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear(perform: loadData)
    }

    func loadData() {
        if let savedCigarettesPerDay = UserDefaults.standard.value(forKey: "cigarettesPerDay") as? Double {
            cigarettesPerDay = savedCigarettesPerDay
        }
        if let savedPackCost = UserDefaults.standard.value(forKey: "packCost") as? Double {
            packCost = savedPackCost
        }
        installationDateTimestamp = UserDefaults.standard.double(forKey: "installationDate")
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}

