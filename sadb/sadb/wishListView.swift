//
//  wishListView.swift
//  sadb
//
//  Created by Studente on 05/07/24.
//

import SwiftUI

struct WishItem: Identifiable {
    let id = UUID()
    let name: String
    let cost: String
    let equivalent: String
    let isActive: Bool
}

struct wishListView: View {
    let wishList = [
        WishItem(name: "Occhiali da sole", cost: "80€", equivalent: "16 pacchetti di sigarette", isActive: true),
        WishItem(name: "Borsa", cost: "100€", equivalent: "20 pacchetti di sigarette", isActive: true),
        WishItem(name: "Airpods", cost: "150€", equivalent: "30 pacchetti di sigarette", isActive: false),
        WishItem(name: "Iphone", cost: "1.200€", equivalent: "240 pacchetti di sigarette", isActive: false),
        WishItem(name: "Viaggio", cost: "2.000€", equivalent: "400 pacchetti di sigarette", isActive: false)
    ]
    
    var body: some View {
        VStack{
            Text("Lista dei desideri")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            List(wishList) { item in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(item.name)
                            .font(.title2)
                            .fontWeight(item.isActive ? .bold : .regular)
                            .foregroundColor(item.isActive ? .primary : .gray)
                        Text("\(item.cost) = \(item.equivalent)")
                            .foregroundColor(item.isActive ? .primary : .gray)
                    }
                    .padding(.vertical, 10)
                }
                .listStyle(PlainListStyle())
        }
      
    }
}

#Preview {
    wishListView()
}
