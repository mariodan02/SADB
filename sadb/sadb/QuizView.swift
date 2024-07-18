import SwiftUI
import FirebaseCore

struct QuizView: View {
    @State private var cigarettesPerDay: Double = 0
    @State private var packCost: Double = 0.0
    @State private var reasonToQuit: String = ""
    
    @State private var showAlert: Bool = false
    @State private var quizCompleted: Bool = false
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2 // Imposta il numero minimo di cifre decimali
        return formatter
    }()
    
    @StateObject private var viewModel = QuizViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    Text("Parlaci di te")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    Text("Quante sigarette fumi in media al giorno?")
                        .padding(5)
                    TextField("", value: $cigarettesPerDay, formatter: NumberFormatter())
                        .padding()
                        .frame(width: 70, height: 30)
                        .overlay(RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(10)
                        .keyboardType(.decimalPad)
                }
                
                VStack(alignment: .leading) {
                    Text("Quanto costa un pacchetto di sigarette?")
                        .padding(5)
                    HStack {
                        TextField("", value: $packCost, formatter: numberFormatter)
                            .padding()
                            .frame(width: 70, height: 30)
                            .overlay(RoundedRectangle(cornerRadius: 7)
                                .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.leading, 10)
                            .keyboardType(.decimalPad)
                        Text("€")
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Perché vuoi smettere di fumare?")
                        .padding(5)
                    TextField("", text: $reasonToQuit)
                        .padding()
                        .frame(height: 200)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(10)
                }
                
                Button(action: {
                    if cigarettesPerDay > 0 && packCost > 0 && !reasonToQuit.isEmpty {
                        viewModel.pushNewValue(cigarettesPerDay: cigarettesPerDay, packCost: packCost, reasonToQuit: reasonToQuit)
                        quizCompleted = true
                    } else {
                        showAlert = true
                    }
                }) {
                    Text("Continua")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Errore"), message: Text("Per favore, compila tutti i campi."), dismissButton: .default(Text("OK")))
                }
                
                NavigationLink(destination: ContentView(), isActive: $quizCompleted) {
                    EmptyView()
                }
                
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden() // Hide the back button
            .onAppear {
                viewModel.checkQuizCompletion { completed in
                    if completed {
                        quizCompleted = true
                    }
                }
            }
            
        }
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}

