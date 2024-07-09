import SwiftUI

struct progressView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Denaro risparmiato e giorni senza fumare
                HStack {
                    VStack {
                        Image(systemName: "eurosign")
                            .font(.largeTitle)
                        Text("120")
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                        Text("Denaro risparmiato")
                            .font(.caption)
                    }
                    Spacer()
                    VStack {
                        Image(systemName: "clock")
                            .font(.largeTitle)
                        Text("12")
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                        Text("Giorni senza fumare")
                            .font(.caption)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
                
                // Grafico giornaliero
                VStack {
                    Image(systemName: "chart.pie")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    Text("Grafico settimanale")
                        .font(.headline)
                }
                .padding(.top, 20)
                
                // Bottoni
                VStack(spacing: 15) {
                    NavigationLink(destination: GoalsView()) {
                        Text("Obiettivi raggiunti")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: wishListView()) {
                        Text("Lista dei desideri")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: healthView()) {
                        Text("Benefici sulla salute")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .background(Color.green.opacity(0.1))
            .navigationTitle("Progressi")
            .navigationBarTitleDisplayMode(.large)
            .scrollContentBackground(.hidden)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    progressView()
}
