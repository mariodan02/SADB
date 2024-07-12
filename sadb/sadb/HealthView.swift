import SwiftUI

struct HealthView: View {
    var body: some View {
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
            
            VStack {
                HealthBenefitRow(icon: "lungs.fill", text: "Benefici sui polmoni")
                HealthBenefitRow(icon: "heart.fill", text: "Benefici sul cuore")
                HealthBenefitRow(icon: "brain.head.profile", text: "Benefici sul cervello")
                HealthBenefitRow(icon: "hand.raised.fill", text: "Benefici sulla pelle")
            }
            .cornerRadius(10)
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Benefici sulla salute")
        .background(Color(.systemGreen).opacity(0.1))
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

struct HealthBenefitRow: View {
    var icon: String
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.red)
            Text(text)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.vertical, 2)
    }
}

struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView()
    }
}

