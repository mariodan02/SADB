//
//  goalsView.swift
//  sadb
//
//  Created by Studente on 05/07/24.
//

import SwiftUI

struct GoalsView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Titolo
                HStack {
                    Spacer()
                    Text("Obiettivi raggiunti")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.top, 20)

                List {
                    ProgressRow(imageName: "clock", text: "Non hai fumato sigarette per 1 giorno intero", achieved: true)
                    ProgressRow(imageName: "clock", text: "Hai risparmiato €10", achieved: true)
                    ProgressRow(imageName: "clock", text: "Hai risparmiato €20", achieved: false)
                }
                .listStyle(PlainListStyle())

                Spacer()
                
            }
            .navigationTitle("")
            .navigationBarHidden(true)
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
    }
}

#Preview {
    GoalsView()
}
