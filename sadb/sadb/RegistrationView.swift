import SwiftUI

struct RegistrationView: View {
    @State private var name: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    @AppStorage("hasRegistered") private var hasRegistered = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Registrazione")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 30)
                
                VStack(alignment: .leading) {
                    Text("Nome")
                        .font(.headline)
                    TextField("Inserisci nome", text: $name)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    
                    Text("Cognome")
                        .font(.headline)
                    TextField("Inserisci cognome", text: $lastName)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    
                    Text("E-mail")
                        .font(.headline)
                    TextField("Inserisci e-mail", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    
                    
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
                    register()
                }) {
                    Text("Registrati")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                NavigationLink(destination: LoginView()) {
                    Text("Hai già un account? Accedi")
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                }
                
                Spacer()
            }
        }
    }
    
    func register() {
        if username.isEmpty || password.isEmpty || name.isEmpty || lastName.isEmpty || email.isEmpty{
            alertTitle = "Errore"
            alertMessage = "Per favore, compila tutti i campi."
            showingAlert = true
        } else {
            let defaults = UserDefaults.standard
            defaults.set(name, forKey: "name")
            defaults.set(lastName, forKey: "lastName")
            defaults.set(email, forKey: "email")
            defaults.set(username, forKey: "username")
            defaults.set(password, forKey: "password")

//            alertTitle = "Successo!"
//            alertMessage = "Registrazione completata con successo."
//            showingAlert = true
            hasRegistered = true
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
