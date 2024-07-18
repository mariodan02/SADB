import SwiftUI

struct HealthView: View {
    @State var organs = [
            Organ(name: "Cuore", image: "cuore", articles: [
                Article(title: "Smettere di fumare può salvare il cuore: ecco perché ", url: URL(string: "https://www.sbmedical.it/blog/smettere-di-fumare-puo-salvare-il-cuore-ecco-perche/")!),
                Article(title: "Smettere di fumare", url: URL(string: "https://swissheart.ch/it/mantensersi-sani/una-vita-sana/smettere-di-fumare")!),
                Article(title: "Tabacco e cuore", url: URL(string: "https://www.stop-tabacco.ch/salute/malattie-cardiovascolari/angina-pectoris/")!),
                Article(title: "Tabagismo e rischio di infarto cardiaco", url: URL(string: "https://www.stop-tabacco.ch/salute/malattie-cardiovascolari/infarto/")!),
                Article(title: "Ipertensione arteriosa e tabagismo", url: URL(string: "https://www.stop-tabacco.ch/salute/malattie-cardiovascolari/ipertensione-arteriosa/")!)
            ]),
            Organ(name: "Polmoni", image: "polmoni", articles: [
                Article(title: "Così i polmoni si 'rigenerano' smettendo di fumare", url: URL(string: "https://www.fondazioneveronesi.it/magazine/articoli/fumo/cosi-i-polmoni-si-rigenerano-dopo-aver-smesso-di-fumare")!),
                Article(title: "Smettere di fumare entro i 35 anni fa tornare i polmoni come nuovi", url: URL(string: "https://www.my-personaltrainer.it/salute-benessere/smettere-di-fumare-entro-i-35-anni-fa-tornare-i-polmoni-come-nuovi.html")!),
                Article(title: "Studio, i polmoni si autoriparano dopo aver smesso di fumare", url: URL(string: "https://www.sigmagazine.it/2020/01/studio-polmoni-riparano-se-stessi/")!),
                Article(title: "Cancro al polmone: cosa c'è da sapere", url: URL(string: "https://www.stop-tabacco.ch/salute/i-tumori-dovuti-al-tabagismo/tumore-del-polmone/")!),
                Article(title: "Asma e tabacco", url: URL(string: "https://www.stop-tabacco.ch/salute/malattie-polmonari/asma-e-tabacco/")!)
            ]),
            Organ(name: "Cervello", image: "cervello", articles: [
                Article(title: "Smettere di fumare fa funzionare meglio il cervello", url: URL(string: "https://www.corriere.it/salute/23_agosto_10/smettere-fumare-fa-funzionare-meglio-cervello-93be54d2-1a4f-11ee-803d-db3b1d875840.shtml")!),
                Article(title: "Cosa succede al cervello se ci si astiene dalle sigarette", url: URL(string: "https://www.fondazioneveronesi.it/magazine/articoli/i-nostri-ricercatori/cosa-succede-al-cervello-durante-lastinenza-da-fumo-di-sigaretta")!),
                Article(title: "Con il fumo il cervello si restringe", url: URL(string: "https://www.fondazioneveronesi.it/magazine/articoli/fumo/con-il-fumo-il-cervello-si-restringe")!),
                Article(title: "Smetti di fumare e avrai un cervello super", url: URL(string: "https://www.corriere.it/salute/sportello_cancro/11_maggio_19/fumare-smettere-super-cervello_9c3e9e36-766b-11e0-b432-72ecee218af7.shtml")!),
                Article(title: "Smettere di fumare: i benefici", url: URL(string: "https://www.humanitas.it/news/smettere-di-fumare-i-benefici/")!)
            ]),
            Organ(name: "Pelle", image: "pelle", articles: [
                Article(title: "Cos'è la faccia del fumatore e perché il fumo invecchia la pelle", url: URL(string: "https://www.my-personaltrainer.it/salute-benessere/faccia-del-fumatore-invecchia-pelle.html")!),
                Article(title: "Fumo e pelle: liberati dalla sigaretta e riacquista la bellezza del viso", url: URL(string: "https://style.corriere.it/benessere/salute/fumo-e-pelle-riacquista-bellezza-viso-dopo-lo-stop/")!),
                Article(title: "Smettere di fumare può ringiovanire la tua pelle, scopri perché", url: URL(string: "https://www.estelitebari.it/smettere-di-fumare-puo-ringiovanire-la-tua-pelle/")!)
            ])
        ]
    
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
                .cornerRadius(10)
                .padding(.horizontal, 10)
                
                Spacer()
                
            }
            .padding()
            .background(Color(.systemGreen).opacity(0.1))
            .onAppear {
                updateHealthBenefits()
            }
        }
        .navigationTitle("Salute")
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
