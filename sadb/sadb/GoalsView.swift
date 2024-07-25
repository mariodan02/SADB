import SwiftUI

struct GoalsView: View {
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var moneySaved: Double
    var daysWithoutSmoking: Int
    
    var body: some View {
        let goals: [(String, String, Bool)] = [
            ("1.circle", "Non ho fumato per 1 giorno", daysWithoutSmoking>=1),
            ("2.circle", "Non ho fumato per 2 giorni", daysWithoutSmoking>=2),
            ("3.circle", "Non ho fumato per 3 giorni", daysWithoutSmoking>=3),
            ("4.circle", "Non ho fumato per 4 giorni", daysWithoutSmoking>=4),
            ("5.circle", "Non ho fumato per 5 giorni", daysWithoutSmoking>=5),
            ("6.circle", "Non ho fumato per 6 giorni", daysWithoutSmoking>=6),
            ("7.circle", "Non ho fumato per 1 settimana", daysWithoutSmoking>=7),
            ("14.circle", "Non ho fumato per 2 settimane", daysWithoutSmoking>=14),
            ("21.circle", "Non ho fumato per 3 settimane", daysWithoutSmoking>=21),
            ("1.circle.fill", "Non ho fumato per 1 mese", daysWithoutSmoking>=31),
            ("2.circle.fill", "Non ho fumato per 2 mesi", daysWithoutSmoking >= 60),
            ("3.circle.fill", "Non ho fumato per 3 mesi", daysWithoutSmoking >= 90),
            ("4.circle.fill", "Non ho fumato per 4 mesi", daysWithoutSmoking >= 120),
            ("5.circle.fill", "Non ho fumato per 5 mesi", daysWithoutSmoking >= 150),
            ("6.circle.fill", "Non ho fumato per 6 mesi", daysWithoutSmoking >= 180),
            ("calendar.circle", "Non ho fumato per 1 anno", daysWithoutSmoking >= 365),
            ("eurosign.circle", "Ho risparmiato €10", moneySaved >= 10),
            ("eurosign.circle", "Ho risparmiato €20", moneySaved >= 20),
            ("eurosign.circle", "Ho risparmiato €30", moneySaved >= 30),
            ("eurosign.circle", "Ho risparmiato €40", moneySaved >= 40),
            ("eurosign.circle", "Ho risparmiato €50", moneySaved >= 50),
            ("eurosign.circle", "Ho risparmiato €100", moneySaved >= 100),
            ("eurosign.circle", "Ho risparmiato €150", moneySaved >= 150),
            ("eurosign.circle", "Ho risparmiato €200", moneySaved >= 200),
        ]
        
        let achievedGoals = goals.filter { $0.2 }
        let unachievedGoals = goals.filter { !$0.2 }
        
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(achievedGoals, id: \.1) { goal in
                        GoalItem(imageName: goal.0, subtitle: goal.1, achieved: goal.2)
                    }
                    ForEach(unachievedGoals, id: \.1) { goal in
                        GoalItem(imageName: goal.0, subtitle: goal.1, achieved: goal.2)
                    }
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
        .frame(width: 130, height: 130)
        .padding(20)
        .background(achieved ? Color.white : Color.black.opacity(0.1))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

