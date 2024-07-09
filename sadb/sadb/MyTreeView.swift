//
//  myTreeView.swift
//  sadb
//
//  Created by Studente on 05/07/24.
//

import SwiftUI

struct MyTreeView: View {
    var body: some View {
        NavigationView{
            ZStack {
                Image("sfondo") .aspectRatio(contentMode: .fit)
                            
                Image("albero")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .offset(y:50)
            }
            .navigationTitle("Il mio albero")
            .navigationBarTitleDisplayMode(.large)
            .scrollContentBackground(.hidden)
            .padding(.bottom, 200)
        }
    }
}

#Preview {
    MyTreeView()
}
