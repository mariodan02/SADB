import SwiftUI
import FirebaseAuth

struct WishItem: Identifiable {
    let id = UUID()
    let name: String
    let cost: String
    let equivalent: String
    let isActive: Bool
    let image: Image
}

struct WishListView: View {
    @StateObject private var wishModel = WishListViewModel() // Initialize the ViewModel
    @State private var isPresentingAddWishItem = false
    
    var body: some View {
        ZStack {
            Color.green.opacity(0.1).edgesIgnoringSafeArea(.all)
            
            VStack {
                if wishModel.wishList.isEmpty {
                    Spacer()
                    Text("Ancora non hai inserito nessun desiderio")
                        .font(.title2)
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(wishModel.wishList) { item in
                            HStack {
                                item.image
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .padding(.trailing, 10)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(item.name)
                                        .font(.title2)
                                        .fontWeight(item.isActive ? .bold : .regular)
                                        .foregroundColor(item.isActive ? .primary : .gray)
                                    Text("\(item.cost) = \(item.equivalent)")
                                        .foregroundColor(item.isActive ? .primary : .gray)
                                }
                            }
                            .listRowBackground(Color.green.opacity(0.2))
                            .padding(.vertical, 10)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .padding(.horizontal, 20)
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarItems(trailing: Button(action: {
                isPresentingAddWishItem = true
            }) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.green)
            })
            .sheet(isPresented: $isPresentingAddWishItem) {
                AddWishItemView(wishModel: wishModel, packCost: wishModel.packCost)
            }
        }
        .navigationBarTitle("Wishlist")
    }
    
    private func deleteItems(at offsets: IndexSet) {
        // Remove items from both the list and database
        offsets.forEach { index in
            let itemToDelete = wishModel.wishList[index]
            wishModel.ref.child("usernames").child(Auth.auth().currentUser!.uid).child("wishList").child(itemToDelete.name).removeValue()
        }
        
        wishModel.wishList.remove(atOffsets: offsets)
    }
}



struct AddWishItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var wishModel: WishListViewModel
    
    @State private var name = ""
    @State private var cost = ""
    @State private var image: UIImage?
    @State private var isImagePickerPresented = false
    @State private var isActionSheetPresented = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var costDouble: Double = 0.0
    @State private var showAlert = false
    @State private var alertMessage = ""
    var packCost: Double?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                isActionSheetPresented = true
                            }) {
                                if let image = image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                } else {
                                    Text("Qui puoi inserire un'immagine")
                                    Image(systemName: "photo.circle.fill")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.gray)
                                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                }
                            }
                            .padding()
                            Spacer()
                        }
                    }
                    
                    TextField("Cosa vuoi comprare?", text: $name)
                    
                    TextField("Prezzo (in euro)", text: $cost)
                        .keyboardType(.decimalPad)
                        .onChange(of: cost) { newValue in
                            if let doubleValue = Double(newValue) {
                                costDouble = doubleValue
                            } else {
                                costDouble = 0.0
                            }
                        }
                }
                
                Button(action: {
                    if name.isEmpty {
                        alertMessage = "Inserisci il nome del desiderio"
                        showAlert = true
                        return
                    } else if cost.isEmpty {
                        alertMessage = "Inserisci il costo del pacchetto."
                        showAlert = true
                    } else if costDouble == 0 {
                        alertMessage = "Inserisci un valore valido per il costo del pacchetto."
                        showAlert = true
                    } else {
                        let imageData = image?.jpegData(compressionQuality: 0.8)
                        wishModel.pushNewValue(wishName: name, wishCost: costDouble, imageData: imageData)
                        wishModel.loadWishes() // Reload wishes after adding new item
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Aggiungi")
                }
            }
            .navigationBarTitle("Nuovo Desiderio", displayMode: .inline)
            .navigationBarItems(trailing: Button("Annulla") {
                presentationMode.wrappedValue.dismiss()
            })
            .actionSheet(isPresented: $isActionSheetPresented) {
                ActionSheet(title: Text("Scegli una fonte"), buttons: [
                    .default(Text("Fotocamera")) {
                        sourceType = .camera
                        isImagePickerPresented = true
                    },
                    .default(Text("Libreria fotografica")) {
                        sourceType = .photoLibrary
                        isImagePickerPresented = true
                    },
                    .cancel()
                ])
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $image, sourceType: sourceType)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Errore"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .foregroundColor(.green)
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var image: UIImage?
        
        init(image: Binding<UIImage?>) {
            _image = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                image = uiImage
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


#Preview {
    WishListView()
}
