import SwiftUI

struct WishItem: Identifiable {
    let id = UUID()
    let name: String
    let cost: String
    let equivalent: String
    let isActive: Bool
    let image: Image
}

struct WishListView: View {
    @State private var wishList = [WishItem]() // Empty initial list
    @State private var isPresentingAddWishItem = false
    
    var body: some View {
        ZStack {
            Color.green.opacity(0.1).edgesIgnoringSafeArea(.all)
            
            VStack {
                if wishList.isEmpty {
                    Spacer()
                    Text("Ancora non hai inserito nessun desiderio")
                        .font(.title2)
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(wishList) { item in
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
                AddWishItemView(wishList: $wishList)
            }
        }
        .navigationBarTitle("Wishlist")
    }
    
    private func deleteItems(at offsets: IndexSet) {
        wishList.remove(atOffsets: offsets)
    }
}

struct AddWishItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var wishList: [WishItem]
    
    @State private var name = ""
    @State private var cost = ""
    @State private var image: UIImage?
    @State private var isImagePickerPresented = false
    @State private var isActionSheetPresented = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showAlert = false
    @State private var showNameAlert = false // New state for name validation alert
    @AppStorage("packCost") private var packCost: String = "0.0"

    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
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
                                Text("- Qui puoi inserire un'immagine del desiderio (opzionale)-")
                                Image(systemName: "photo.circle.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            }
                        }
                        .padding()
                    }
                    
                    TextField("Cosa vuoi comprare?", text: $name)
                    
                    TextField("Prezzo (in euro)", text: $cost)
                        .keyboardType(.decimalPad)
                }
                
                Button(action: {
                    if name.isEmpty {
                        showNameAlert = true
                        return
                    }
                    
                    guard let costValue = Double(cost), let packCostValue = Double(packCost) else { return }
                    let equivalentPacks = Int(costValue / packCostValue)
                    let equivalentText = "\(equivalentPacks) pacchetti di sigarette"
                    let newItem = WishItem(
                        name: name,
                        cost: "\(cost)€",
                        equivalent: equivalentText,
                        isActive: true,
                        image: image != nil ? Image(uiImage: image!) : Image("gift")
                    )
                    wishList.append(newItem)
                    presentationMode.wrappedValue.dismiss()
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
                    message: Text("Inserisci un numero valido per il prezzo"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(isPresented: $showNameAlert) {
                Alert(
                    title: Text("Errore"),
                    message: Text("Inserisci il nome del desiderio"),
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
