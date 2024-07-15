//
//  LungsView.swift
//  sadb
//
//  Created by Studente on 12/07/24.
//

import SwiftUI

struct LungsView: View {
    var body: some View {
        
        VStack{
            Image("polmoni")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 250)
                .shadow(radius: 5)
            Spacer()
        }
        .background(Color.green.opacity(0.1))
        .navigationTitle("Benefici sui polmoni")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    LungsView()
}
