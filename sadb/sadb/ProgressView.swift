import SwiftUI

struct ProgressView: View {
    
    @AppStorage("cigarettesPerDay") private var cigarettesPerDay: String = ""
    @AppStorage("packCost") private var packCost: String = ""
    @AppStorage("installationDate") private var installationDateTimestamp: Double = Date().timeIntervalSince1970
    
    
    var installationDate: Date {
        get {
            Date(timeIntervalSince1970: installationDateTimestamp)
        }
        set {
            installationDateTimestamp = newValue.timeIntervalSince1970
        }
    }
    
    var daysSinceInstallation: Int {
        let currentDate = Date()
        let days = Calendar.current.dateComponents([.day], from: installationDate, to: currentDate).day
        return days ?? 0
    }
    
    var moneySaved: Double {
        let dailyCost = (Double(cigarettesPerDay) ?? 0) * (Double(packCost) ?? 0) / 20
        return dailyCost * Double(daysSinceInstallation)
    }
    
    var body: some View {
        NavigationView {
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
                    Text("\(daysSinceInstallation)")
                        .font(.system(size: 50))
                    Text("Giorni senza fumare")
                        .font(.caption)
                }
            
            }
            .padding(.horizontal, 60)
            .padding(.top, 40)
            // Grafico1
            VStack {
                Image(systemName: "chart.pie")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                Text("Grafico ")
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
                    Text("Benefici sulla salute")
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
        .navigationTitle("I miei progressi")
        .navigationBarTitleDisplayMode(.large)
    }
}
}

struct progressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}

