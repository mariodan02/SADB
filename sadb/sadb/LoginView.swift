import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @AppStorage("isLogged") private var isLogged = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Benvenuto")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            
            VStack(alignment: .leading) {
                Text("Username")
                    .font(.headline)
                TextField("Inserisci username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                Text("Password")
                    .font(.headline)
                SecureField("Inserisci password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 40)
            
            Button(action: {
                login()
            }) {
                Text("Accedi")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Errore"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
            Spacer()
        }
    }
    
    func login() {
        if username.isEmpty || password.isEmpty {
            alertMessage = "Per favore, compila tutti i campi."
            showingAlert = true
        } else {
            let defaults = UserDefaults.standard
            if let savedUsername = defaults.string(forKey: "username"),
               let savedPassword = defaults.string(forKey: "password"),
               username == savedUsername && password == savedPassword {
                
                //login ha avuto successo
                isLogged = true
            } else {
                // Login fallito
                alertMessage = "Username o password errati."
                showingAlert = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

