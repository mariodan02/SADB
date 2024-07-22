import SwiftUI
import Network

struct ContentView: View {
    @State private var isConnected: Bool = true
    
    var body: some View {
        ZStack {
            if isConnected {
                TabView{
                    ProgressView()
                        .tabItem {
                            Label("Progressi", systemImage: "sparkles")
                        }
                    
                    MountainView()
                        .tabItem {
                            Label("Il mio albero", systemImage: "flag.fill")
                        }
                    
                    DiaryView()
                        .tabItem {
                            Label("Diario", systemImage: "list.bullet")
                        }
                }
                .accentColor(.green)
                .navigationBarBackButtonHidden()
            } else {
                VStack {
                    Text("Errore di connessione")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text("Controlla la tua connessione a Internet e riprova.")
                        .font(.body)
                        .padding()
                }
            }
        }
        .onAppear(perform: checkConnection)
    }
    
    func checkConnection() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    isConnected = true
                } else {
                    isConnected = false
                }
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}

#Preview {
    ContentView()
}
