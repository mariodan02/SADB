import SwiftUI

struct ProgressView: View {
    
    @AppStorage("e_mail") private var e_mail : String = ""
    @StateObject private var authModel = AuthModel()
    @State private var username: String?

    var body: some View {
        
        NavigationStack {
            VStack {
                if let username = username {
                    Text("Ciao, \(username)")
                } else {
                    Text("Utente non loggato")
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
            .background(Color.green.opacity(0.1))
            .navigationTitle("Progressi")
            .navigationBarTitleDisplayMode(.large)
        }
        // .onAppear(perform: loadData)
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}

