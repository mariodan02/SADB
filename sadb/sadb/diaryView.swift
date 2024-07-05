//
//  diaryView.swift
//  sadb
//
//  Created by Studente on 05/07/24.
//

import SwiftUI
import UIKit

struct diaryView: View {
    var body: some View {
        VStack {
            // Top header
            HStack {
                Spacer()
                Text("Diario / Percorso")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top, 50)
            
            // inseriamo Calendar View
            VStack {
                CalendarPicker()
            }
            .padding(.vertical, 20)
            
            
            Button(action: {
                // Azione per il button
            }) {
                Text("Come sta andando?")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 50)
            
            // Custom tab bar
            CustomTabBar()
        }
    }
}

struct CalendarPicker: UIViewRepresentable {
    func makeUIView(context: Context) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        return datePicker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        // Aggiorna la view
    }
}

struct CustomTabBar: View {
    var body: some View {
        HStack {
            VStack {
                Image(systemName: "list.bullet")
                Text("Diario")
            }
            .padding()
            .foregroundColor(.green)
            Spacer()
            VStack {
                Image(systemName: "leaf")
                Text("Il mio albero")
            }
            .padding()
            .foregroundColor(.gray)
            Spacer()
            VStack {
                Image(systemName: "sparkles")
                Text("Progressi")
            }
            .padding()
            .foregroundColor(.gray)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .background(Color.white.shadow(radius: 2))
    }
}

#Preview {
    diaryView()
}
