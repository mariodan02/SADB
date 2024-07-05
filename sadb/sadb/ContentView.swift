import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            // Top header
            HStack {
                Spacer()
                Text("Progressi")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top, 20)
            
            // Savings and days without smoking
            HStack {
                VStack {
                    Text("€")
                        .font(.largeTitle)
                    Text("120")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                    Text("Denaro risparmiato")
                        .font(.caption)
                }
                Spacer()
                VStack {
                    Text("🕒")
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
            
            // Weekly chart placeholder
            VStack {
                Image(systemName: "chart.pie")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                Text("Grafico settimanale")
                    .font(.headline)
            }
            .padding(.top, 20)
            
            // Buttons
            VStack(spacing: 15) {
                Button(action: {
                    // Action for Obbiettivi raggiunti
                }) {
                    Text("Obbiettivi raggiunti")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // Action for Lista dei desideri
                }) {
                    Text("Lista dei desideri")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // Action for Benefici sulla salute
                }) {
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
            
            // Bottom navigation bar
            HStack {
                Spacer()
                VStack {
                    Image(systemName: "book")
                    Text("Diario")
                }
                Spacer()
                VStack {
                    Image(systemName: "tree")
                    Text("Il mio albero")
                }
                Spacer()
                VStack {
                    Image(systemName: "chart.bar")
                    Text("Progressi")
                }
                Spacer()
            }
            .padding(.bottom, 20)
            .frame(height: 50)
            .background(Color.gray.opacity(0.1))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
