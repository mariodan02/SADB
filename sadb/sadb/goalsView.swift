//
//  goalsView.swift
//  sadb
//
//  Created by Studente on 05/07/24.
//

import SwiftUI

struct GoalsView: View {
    var body: some View {
        NavigationStack{
            VStack {
                List {
                    ProgressRow(imageName: "clock", text: "Non ho fumato per 1 giorno", achieved: true)
                    ProgressRow(imageName: "clock", text: "Non ho fumato per 2 giorni", achieved: true)
                    ProgressRow(imageName: "clock", text: "Non ho fumato per 3 giorni", achieved: true)
                    ProgressRow(imageName: "clock", text: "Non ho fumato per 4 giorni", achieved: true)
                    ProgressRow(imageName: "clock", text: "Non ho fumato per 5 giorni", achieved: true)
                    ProgressRow(imageName: "clock", text: "Non ho fumato per 6 giorni", achieved: true)
                    ProgressRow(imageName: "clock", text: "Non ho fumato per 1 settimana", achieved: true)
                    ProgressRow(imageName: "clock", text: "Non ho fumato per 2 settimane", achieved: true)
                    ProgressRow(imageName: "clock", text: "Non ho fumato per 3 settimane", achieved: true)
                    ProgressRow(imageName: "clock", text: "Non ho fumato per 4 settimane", achieved: true)
                    ProgressRow(imageName: "clock", text: "Non ho fumato per 1 mese", achieved: true)
                    ProgressRow(imageName: "eurosign.circle", text: "Ho risparmiato €10", achieved: true)
                    ProgressRow(imageName: "eurosign.circle", text: "Ho risparmiato €20", achieved: false)
                    ProgressRow(imageName: "eurosign.circle", text: "Ho risparmiato €50", achieved: false)
                    ProgressRow(imageName: "eurosign.circle", text: "Ho risparmiato €100", achieved: false)
                    
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal, 20)
                Spacer()
            }
            .navigationTitle("Obiettivi raggiunti")
            .background(Color.green.opacity(0.1))
        }
    }
}

struct ProgressRow: View {
    var imageName: String
    var text: String
    var achieved: Bool
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(achieved ? .black : .gray)
            Text(text)
                .foregroundColor(achieved ? .black : .gray)
        }
        .listRowBackground(Color.green.opacity(0.2))
    }
}

#Preview {
    GoalsView()
}

