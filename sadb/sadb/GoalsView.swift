import SwiftUI

struct GoalsView: View {
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        GoalItem(imageName: "1.circle", subtitle: "Non ho fumato per 1 giorno", achieved: true)
                                               GoalItem(imageName: "2.circle", subtitle: "Non ho fumato per 2 giorni", achieved: true)
                                               GoalItem(imageName: "3.circle", subtitle: "Non ho fumato per 3 giorni", achieved: true)
                                               GoalItem(imageName: "4.circle", subtitle: "Non ho fumato per 4 giorni", achieved: true)
                                               GoalItem(imageName: "5.circle", subtitle: "Non ho fumato per 5 giorni", achieved: true)
                                               GoalItem(imageName: "6.circle", subtitle: "Non ho fumato per 6 giorni", achieved: true)
                                               GoalItem(imageName: "7.circle", subtitle: "Non ho fumato per 1 settimana", achieved: true)
                                               GoalItem(imageName: "14.circle", subtitle: "Non ho fumato per 2 settimane", achieved: false)
                                               GoalItem(imageName: "21.circle", subtitle: "Non ho fumato per 3 settimane", achieved: false)
                                               GoalItem(imageName: "28.circle", subtitle: "Non ho fumato per 4 settimane", achieved: false)
                                               GoalItem(imageName: "1.circle.fill", subtitle: "Non ho fumato per 1 mese", achieved: false)
                                                GoalItem(imageName: "2.circle.fill", subtitle: "Non ho fumato per 2 mesi", achieved: false)
                                                GoalItem(imageName: "3.circle.fill", subtitle: "Non ho fumato per 3 mesi", achieved: false)
                                                GoalItem(imageName: "4.circle.fill", subtitle: "Non ho fumato per 4 mesi", achieved: false)
                                                GoalItem(imageName: "5.circle.fill", subtitle: "Non ho fumato per 5 mesi", achieved: false)
                                                GoalItem(imageName: "6.circle.fill", subtitle: "Non ho fumato per 6 mesi", achieved: false)
                                               GoalItem(imageName: "eurosign.circle", subtitle: "Ho risparmiato €10", achieved: false)
                                               GoalItem(imageName: "eurosign.circle", subtitle: "Ho risparmiato €20", achieved: false)
                                               GoalItem(imageName: "eurosign.circle", subtitle: "Ho risparmiato €50", achieved: false)
                                               GoalItem(imageName: "eurosign.circle", subtitle: "Ho risparmiato €100", achieved: false)
                    }
                    .padding()
                }
                Spacer()
            }
            .navigationBarTitle("Obiettivi raggiunti")
            .background(Color.green.opacity(0.1))
        
    }
}

struct GoalItem: View {
    var imageName: String
    var subtitle: String
    var achieved: Bool
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.green)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 130, height: 130) // Ensuring all items have the same size
        .padding(20)
        .background(achieved ? Color.white : Color.black.opacity(0.1))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    GoalsView()
}

