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
                .listStyle(InsetGroupedListStyle())

                Spacer()
                
                CustomTabBarGoals()
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

struct CustomTabBarGoals: View {
    var body: some View {
        HStack {
            Button(action: {
                // Azione per il tab "Diario"
                print("Diario tab clicked")
            }) {
                VStack {
                    Image(systemName: "list.bullet")
                    Text("Diario")
                }
                .padding()
                .foregroundColor(.green)
            }
            Spacer()
            Button(action: {
                // Azione per il tab "Il mio albero"
                print("Il mio albero tab clicked")
            }) {
                VStack {
                    Image(systemName: "leaf")
                    Text("Il mio albero")
                }
                .padding()
                .foregroundColor(.gray)
            }
            Spacer()
            Button(action: {
                // Azione per il tab "Progressi"
                print("Progressi tab clicked")
            }) {
                VStack {
                    Image(systemName: "sparkles")
                    Text("Progressi")
                }
                .padding()
                .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .background(Color.white.shadow(radius: 2))
    }
}

#Preview {
    GoalsView()
}
