import SwiftUI
import Firebase

struct RegistrationView: View {
    @State private var name: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    //@AppStorage("hasRegistered") private var hasRegistered = false
    @AppStorage("isLogged") private var isLogged: Bool = false
    @StateObject var authModel = AuthModel()
    
    // New state for navigation
    @AppStorage("navigateToQuiz") private var navigateToQuiz = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Spacer()
                    
                    Text("Registrati")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    
                    VStack(alignment: .leading) {
                        Text("Nome")
                            .font(.headline)
                        TextField("Inserisci nome", text: $name)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5.0)
                            .padding(.bottom, 20)
                            .disableAutocorrection(true)
                        
                        Text("Cognome")
                            .font(.headline)
                        TextField("Inserisci cognome", text: $lastName)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5.0)
                            .padding(.bottom, 20)
                            .disableAutocorrection(true)
                        
                        Text("E-mail")
                            .font(.headline)
                        TextField("Inserisci e-mail", text: $email)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5.0)
                            .padding(.bottom, 20)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        Text("Username")
                            .font(.headline)
                        TextField("Inserisci username", text: $username)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5.0)
                            .padding(.bottom, 20)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        Text("Password")
                            .font(.headline)
                        SecureField("Inserisci password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5.0)
                            .padding(.bottom, 20)
                            .textContentType(.none)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .textInputAutocapitalization(.never)
                        
                        Text("Conferma Password")
                            .font(.headline)
                        SecureField("Conferma password", text: $confirmPassword)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5.0)
                            .padding(.bottom, 20)
                            .textContentType(.none)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .textInputAutocapitalization(.never)
                    }
                    .padding(.horizontal, 40)
                    
                    Button(action: {
                        if name.isEmpty || lastName.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty {
                            alertTitle = "Campi Vuoti"
                            alertMessage = "Per favore, riempi tutti i campi."
                            showingAlert = true
                        } else if !isValidEmail(email: email) {
                            alertTitle = "Email non valida"
                            alertMessage = "Per favore inserisci un'email valida."
                            showingAlert = true
                        } else if password != confirmPassword {
                            alertTitle = "Password non corrispondenti"
                            alertMessage = "Le password non corrispondono. Per favore, riprova."
                            password = ""
                            confirmPassword = ""
                            showingAlert = true
                        } else {
                            authModel.pushNewValue(username: username, email: email, password: password) { error in
                                if let error = error {
                                    print("Operation failed with error: \(error.localizedDescription)")
                                    alertTitle = "Errore"
                                    alertMessage = error.localizedDescription
                                    showingAlert = true
                                } else {
                                    print("Operation successful!")
                                    //hasRegistered = true
                                    navigateToQuiz = true
                                    isLogged = true
                                }
                            }
                        }
                    }) {
                        Text("Registrati")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    
                    NavigationLink(destination: QuizView(), isActive: $navigateToQuiz) {
                        EmptyView()
                    }
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Hai già un account? Accedi")
                            .foregroundColor(.green)
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "(?i)[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
