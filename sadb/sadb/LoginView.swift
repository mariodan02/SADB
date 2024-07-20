import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var loginSuccessful = false
    
    @AppStorage("isLogged") private var isLogged = false
    @AppStorage("e_mail") private var e_mail: String = ""
    
    @StateObject var authModel = AuthModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Accedi")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 40)
                
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.headline)
                    TextField("Inserisci email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                        .autocapitalization(.none)
                    
                    Text("Password")
                        .font(.headline)
                    SecureField("Inserisci password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5.0)
                        .autocapitalization(.none)
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 40)
                
                Button(action: {
                    authModel.login(email: email, password: password) { result in
                        switch result {
                        case .success(let authDataResult):
                            // Handle successful login
                            print("Login successful for user: \(authDataResult.user.email ?? "")")
                            isLogged = true // Set isLogged to true
                            e_mail = email
                            loginSuccessful = true // Set loginSuccessful to true to navigate
                        case .failure(let error):
                            // Handle login error
                            print("Login failed with error: \(error.localizedDescription)")
                            alertMessage = error.localizedDescription
                            showingAlert = true
                        }
                    }
                }){
                    Text("Accedi")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Errore"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                NavigationLink(destination: RegistrationView()) {
                    Text("Non hai ancora un account? Registrati")
                        .foregroundColor(.green)
                        .padding(.top, 10)
                }
                
                NavigationLink(destination: ProgressView(), isActive: $loginSuccessful) {
                    EmptyView()
                }
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
