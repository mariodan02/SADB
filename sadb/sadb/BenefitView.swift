//
//  BenefitView.swift
//  sadb
//
//  Created by Studente on 15/07/24.
//

import SwiftUI

struct BenefitView: View {
    @Binding var organ: Organ
    
    var body: some View {
        VStack{
            Image(organ.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height:250)
            Spacer()
        }
        .navigationTitle("Benefici su \(organ.name)")
    }
}

#Preview {
    BenefitView(organ: .constant(Organ(name: "Polmoni", image: "polmoni")))
}
