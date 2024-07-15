import SwiftUI

struct HealthView: View {
    @State var organs = [Organ(name: "Cuore", image: "cuore"), Organ(name: "Polmoni", image: "polmoni"), Organ(name: "Cervello", image: "cervello"), Organ(name: "Pelle", image: "pelle")]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Miglioramento della salute")
                    .font(.headline)
                
                HStack(spacing: 30) {
                    HealthProgressView(percentage: 40, label: "Polmoni")
                    HealthProgressView(percentage: 30, label: "Cuore")
                    HealthProgressView(percentage: 60, label: "Cervello")
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
            .navigationBarTitle("Benefici sulla salute")
            .background(Color(.systemGreen).opacity(0.1))
        }
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

