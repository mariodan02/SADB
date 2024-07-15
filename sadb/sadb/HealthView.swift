import SwiftUI

struct HealthView: View {
    @State var organs = [Organ(name: "Cuore", image: "cuore", articles: [
        Article(title: "Articolo 1", url: URL(string: "https://www.fondazioneveronesi.it/magazine/articoli/lesperto-risponde/smettere-di-fumare-puo-cambiare-la-vita-di-un-cardiopatico#:~:text=In%20una%20recente%20revisione%20di,confronto%20a%20quelli%20che%20hanno")!),
        Article(title: "Articolo 2", url: URL(string: "https://example.com/article2")!),
        Article(title: "Articolo 3", url: URL(string: "https://example.com/article3")!)
    ]), Organ(name: "Polmoni", image: "polmoni", articles: [
        Article(title: "Articolo 1", url: URL(string: "https://www.salute.gov.it/portale/fumo/dettaglioContenutiFumo.jsp?lingua=italiano&id=5579&area=fumo&menu=vuoto#:~:text=Il%20fumo%20di%20tabacco%2C%20in,di%20cancro%2C%20cardiopatie%2C%20vasculopatie.")!),
        Article(title: "Articolo 2", url: URL(string: "https://example.com/article2")!),
        Article(title: "Articolo 3", url: URL(string: "https://example.com/article3")!)
    ]), Organ(name: "Cervello", image: "cervello", articles: [
        Article(title: "Articolo 1", url: URL(string: "https://www.salute.gov.it/portale/fumo/dettaglioContenutiFumo.jsp?lingua=italiano&id=5579&area=fumo&menu=vuoto#:~:text=Il%20fumo%20di%20tabacco%2C%20in,di%20cancro%2C%20cardiopatie%2C%20vasculopatie.")!),
        Article(title: "Articolo 2", url: URL(string: "https://example.com/article2")!),
        Article(title: "Articolo 3", url: URL(string: "https://example.com/article3")!)
    ]), Organ(name: "Pelle", image: "pelle", articles: [
        Article(title: "Articolo 1", url: URL(string: "https://www.salute.gov.it/portale/fumo/dettaglioContenutiFumo.jsp?lingua=italiano&id=5579&area=fumo&menu=vuoto#:~:text=Il%20fumo%20di%20tabacco%2C%20in,di%20cancro%2C%20cardiopatie%2C%20vasculopatie.")!),
        Article(title: "Articolo 2", url: URL(string: "https://example.com/article2")!),
        Article(title: "Articolo 3", url: URL(string: "https://example.com/article3")!)
    ])]
    
    @State private var dailyCigarettes = 20
    @State private var lungPercentage = 0
    @State private var heartPercentage = 0
    @State private var brainPercentage = 0

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Miglioramento della salute")
                    .font(.headline)
                
                HStack(spacing: 30) {
                    HealthProgressView(percentage: lungPercentage, label: "Polmoni")
                    HealthProgressView(percentage: heartPercentage, label: "Cuore")
                    HealthProgressView(percentage: brainPercentage, label: "Cervello")
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                
                List {
                    ForEach($organs, id: \.id) { $organ in
                        NavigationLink(destination: BenefitView(organ: $organ)) {
                            HStack {
                                Image(organ.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipped()
                                    .cornerRadius(10)
                                Text(organ.name)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
                Spacer()
                
            }
            .padding()
            .background(Color(.systemGreen).opacity(0.1))
            .onAppear {
                            updateHealthBenefits()
                        }
        }
        .navigationTitle("Benefici sulla salute")
    }
    
    func updateHealthBenefits() {
        //modificare il metodo
          lungPercentage = max(0, 100 - dailyCigarettes * 2)
          heartPercentage = max(0, 100 - dailyCigarettes * 3)
          brainPercentage = max(0, 100 - dailyCigarettes * 4)
      }
}

struct HealthProgressView: View {
    var percentage: Int
    var label: String
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(Color.green)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(Double(percentage) / 100.0, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.green)
                    .rotationEffect(Angle(degrees: 270.0))
                
                Text("\(percentage)%")
                    .font(.headline)
                    .bold()
            }
            .frame(width: 70, height: 70)
            
            Text(label)
                .font(.subheadline)
                .padding(.top, 5)
        }
    }
}

struct Article: Identifiable, Codable {
    var id = UUID()
    var title: String
    var url: URL
}

struct Organ: Identifiable, Codable {
    var id = UUID()
    var name: String
    var image: String
    var articles: [Article]
}


#Preview{
    HealthView()
}
