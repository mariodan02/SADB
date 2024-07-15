//
//  Scheda.swift
//  sadb
//
//  Created by Studente on 12/07/24.
//

import SwiftUI

struct Scheda: View {
    @Binding var immagine: Imagine //per passare variabile da view a subview si fa con la coppia state-binding
    //la variabile contrassegnata con binding verrà passata dalla view di livello superiore
    //per passare le variabili alla subview si deve utilizzare $
    @Binding var immagini: [Imagine]
    
    //l'immagine visualizzata nella Scheda
    @State private var immagineGrande: Image?
    
    //state invoca nuovamente la proprietà body, ridisegnandola-> non c'è bisogno di gestire il refresh
    var body: some View {
        ScrollView{
            VStack{ //mette tutti gli elementi al suo interno uno sotto l'altro
                TextField("Intestazione", text: $immagine.intestazione) //serve per modificare il titolo dell'immagine
                    .font(.system(size: 30))
                    .multilineTextAlignment(.center)
                    .padding()
                if let imgGrande=immagineGrande{
                    imgGrande
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                }
                
                
                
            }
        }
    
    }
    
    
}

#Preview {
    //per avere la preview questa cosa si deve fare per forza
    //serve solo per vedere la preview statica, altrimenti da' errore
    Scheda(immagine: .constant(Imagine(intestazione: "Nome Fiore", nomeImmagine: "fiori")), immagini: .constant([Imagine(intestazione: "Nome Fiore", nomeImmagine: "fiori")]))
}
