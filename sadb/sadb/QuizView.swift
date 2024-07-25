import SwiftUI
import FirebaseCore

struct QuizView: View {
    @State private var cigarettesPerDay: String = ""
    @State private var packCost: String = ""
    @State private var reasonToQuit: String = ""
    @State private var alertMessage = ""
    
    @State private var showAlert: Bool = false
    @State private var quizCompleted: Bool = false
    
    @AppStorage("navigateToQuiz") private var navigateToQuiz = false
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        return formatter
    }()
    
    @StateObject private var viewModel = QuizViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView{
                HStack {
                    Spacer()
                    Text("Parlaci di te")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    Text("Quante sigarette fumi in media al giorno?")
                        .font(.headline)
                        .padding(.top, 20)
                    TextField("", text: $cigarettesPerDay)
                        .padding()
                        .frame(width: 70, height: 30)
                        .padding(5)
                        .keyboardType(.decimalPad)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5.0)
                        .padding(.leading, 10)
                }
                
                VStack(alignment: .leading) {
                    Text("Quanto costa un pacchetto di sigarette?")
                        .font(.headline)
                    HStack {
                        TextField("", text: $packCost)
                            .padding()
                            .frame(width: 70, height: 30)
                            .padding(5)
                            .keyboardType(.decimalPad)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5.0)
                            .padding(.leading, 10)
                        
                        Text("€")
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Perché vuoi smettere di fumare?")
                        .font(.headline)
                    TextEditor(text: $reasonToQuit)
                        .padding()
                        .frame(height: 200)
                        .multilineTextAlignment(.leading)
                        .padding(5)
                        .keyboardType(.default)
                        .scrollContentBackground(.hidden)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5.0)
                        .padding(.top, 5)
                        .padding(.horizontal, 10)
                }
                
                Button(action: {
                    let sanitizedPackCost = packCost.replacingOccurrences(of: ",", with: ".")
                                        
                    // Validate each input
                    if cigarettesPerDay.isEmpty || Int(cigarettesPerDay) == nil {
                        alertMessage = "Per favore, inserisci un numero valido per le sigarette fumate."
                        showAlert = true
                    } else if sanitizedPackCost.isEmpty || Double(sanitizedPackCost) == nil {
                        alertMessage = "Per favore, inserisci un numero valido per il costo del pacchetto."
                        showAlert = true
                    } else if reasonToQuit.isEmpty {
                        alertMessage = "Per favore, compila tutti i campi."
                        showAlert = true
                    } else {
                        // All inputs are valid, proceed with the quiz
                        let cigarettesPerDayValue = Int(cigarettesPerDay) ?? 0
                        let packCostValue = Double(sanitizedPackCost) ?? 0.0
                        viewModel.pushNewValue(cigarettesPerDay: cigarettesPerDayValue, packCost: packCostValue, reasonToQuit: reasonToQuit)
                        quizCompleted = true
                        navigateToQuiz = false
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
                    Alert(title: Text("Errore"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                NavigationLink(destination: ContentView(), isActive: $quizCompleted) {
                    EmptyView()
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden() // Hide the back button
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}

