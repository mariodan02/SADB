import SwiftUI

struct HealthView: View {
    @State var organs = [Organ(name: "Cuore", image: "cuore"), Organ(name: "Polmoni", image: "polmoni"), Organ(name: "Cervello", image: "cervello"), Organ(name: "Pelle", image: "pelle")]
    
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


struct Organ: Identifiable, Codable {
    var id = UUID()
    var name: String
    var image: String
}


struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView()
    }
}
