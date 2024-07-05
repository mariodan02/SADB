//
//  progressView.swift
//  sadb
//
//  Created by Studente on 05/07/24.
//

import SwiftUI
import UIKit

struct progressView: View {

    var body: some View {
            VStack {
                // Titolo
                HStack {
                    Spacer()
                    Text("Progressi")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.top, 20)
                
                // Denaro risparmiato e giorni senza fumare
                HStack {
                    VStack {
                        Text("€")
                            .font(.largeTitle)
                        Text("120")
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                        Text("Denaro risparmiato")
                            .font(.caption)
                    }
                    Spacer()
                    VStack {
                        Text("🕒")
                            .font(.largeTitle)
                        Text("12")
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                        Text("Giorni senza fumare")
                            .font(.caption)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
                
                // Grafico giornaliero
                VStack {
                    Image(systemName: "chart.pie")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    Text("Grafico settimanale")
                        .font(.headline)
                }
                .padding(.top, 20)
                
                // Bottoni
                VStack(spacing: 15) {
                    Button(action: {
                        // Action per Obbiettivi raggiunti
                    }) {
                        Text("Obbiettivi raggiunti")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Action per Lista dei desideri
                    }) {
                        Text("Lista dei desideri")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Action per Benefici sulla salute
                    }) {
                        Text("Benefici sulla salute")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                Spacer()
               
            }
        }
    }


    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
#Preview {
    progressView()
}
