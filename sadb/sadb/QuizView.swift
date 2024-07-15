import SwiftUI

struct QuizView: View {
    @AppStorage("cigarettesPerDay") private var cigarettesPerDay: String = ""
    @AppStorage("packCost") private var packCost: String = ""
    @AppStorage("reasonToQuit") private var reasonToQuit: String = ""
    @AppStorage("installationDate") private var installationDateTimestamp: Double = Date().timeIntervalSince1970
    @AppStorage("hasCompletedQuiz") private var hasCompletedQuiz: Bool = false

    @State private var showAlert: Bool = false

    var installationDate: Date {
        get {
            Date(timeIntervalSince1970: installationDateTimestamp)
        }
        set {
            installationDateTimestamp = newValue.timeIntervalSince1970
        }
    }

    var body: some View {
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
                TextField("", text: $cigarettesPerDay)
                    .padding()
                    .frame(width: 70, height: 30)
                    .overlay(RoundedRectangle(cornerRadius: 7)
                        .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(10)
            }
            
            VStack(alignment: .leading) {
                Text("Quanto costa un pacchetto di sigarette?")
                    .padding(5)
                HStack {
                    TextField("", text: $packCost)
                        .padding()
                        .frame(width: 70, height: 30)
                        .overlay(RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.leading, 10)
                    Text("€")
                }
            }

            VStack(alignment: .leading) {
                Text("Perché vuoi smettere di fumare?")
                    .padding(5)
                TextEditor(text: $reasonToQuit)
                    .padding(10)
                    .frame(height: 200)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(10)
            }
            
            Button(action: {
                if cigarettesPerDay.isEmpty || packCost.isEmpty || reasonToQuit.isEmpty {
                    showAlert = true
                } else {
                    hasCompletedQuiz = true
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
            Spacer()
        }
        .padding()
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}
