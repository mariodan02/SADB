import SwiftUI
import Firebase

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
    
    @StateObject var authModel = AuthModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
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
                        authModel.pushNewValue(username: username, email: email, password: password) { error in
                                if let error = error {
                                    // Handle the error
                                    print("Operation failed with error: \(error.localizedDescription)")
                                    // You can also show an alert or update the UI to reflect the error
                                } else {
                                    // Handle the success
                                    print("Operation successful!")
                                    // You can also navigate to another view or update the UI to reflect success
                                }
                            }
                        }){
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
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
