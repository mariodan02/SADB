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
                    ProgressRow(imageName: "clock", text: "Non hai fumato sigarette per 1 giorno intero", achieved: true)
                    ProgressRow(imageName: "clock", text: "Non hai fumato sigarette per 3 giorni", achieved: true)
                    ProgressRow(imageName: "clock", text: "Non hai fumato sigarette per 1 settimana", achieved: true)
                    ProgressRow(imageName: "clock", text: "Hai risparmiato €10", achieved: true)
                    ProgressRow(imageName: "clock", text: "Hai risparmiato €20", achieved: false)
                    ProgressRow(imageName: "clock", text: "Hai risparmiato €50", achieved: false)
                    ProgressRow(imageName: "clock", text: "Hai risparmiato €100", achieved: false)
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

