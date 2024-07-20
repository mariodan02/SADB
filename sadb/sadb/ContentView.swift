
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            ProgressView()
                .tabItem {
                    Label("Progressi", systemImage: "sparkles")
                }
            
            MyTreeView()
                .tabItem {
                    Label("Il mio albero", systemImage: "tree")
                }
            
            DiaryView()
                .tabItem {
                    Label("Diario", systemImage: "list.bullet")
                }
        }
        .accentColor(.green)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ContentView()
}
