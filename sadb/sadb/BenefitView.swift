import SwiftUI
import SafariServices

struct BenefitView: View {
    @Binding var organ: Organ
    @State private var selectedArticle: Article?
    @State private var isSheetPresented = false
    
    var body: some View {
        ScrollView {
            VStack {
                Text("In questa sezione troverai una raccolta di articoli informativi su come il fumo può danneggiare \(organ.name.lowercased()) e i molteplici benefici che smettere di fumare può portare alla tua salute. \nEsplora le risorse per comprendere meglio gli effetti del tabagismo e scopri utili consigli per migliorare il tuo benessere.")
                    .font(.body)
                    .padding([.bottom, .horizontal], 20)

                Spacer()
                
                ForEach(organ.articles) { article in
                    Button(action: {
                        selectedArticle = article
                        isSheetPresented = true
                    }) {
                        LinkPreview(article: article)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                            .frame(maxWidth: UIScreen.main.bounds.width - 40)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 2)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .background(Color(.systemGreen).opacity(0.1)) // Colore di sfondo per lo ScrollView
        .navigationTitle("Benefici su \(organ.name)")
        .sheet(isPresented: $isSheetPresented) {
            if let article = selectedArticle {
                SafariView(url: article.url)
            }
        }
    }
}

struct LinkPreview: View {
    var article: Article
    @State private var imageUrl: URL?
    @State private var title: String = "Loading..."

    var body: some View {
        VStack {
            if let imageUrl = imageUrl {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                        .frame(width: 50, height: 50)
                }
            }
            Text(title)
                .font(.headline)
                .padding(.top, 10) // Aggiungi un po' di spazio tra l'immagine e il titolo
                .onAppear {
                    fetchMetadata(for: article.url)
                }
        }
    }
    
    private func fetchMetadata(for url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let html = String(data: data, encoding: .utf8) else {
                return
            }
            DispatchQueue.main.async {
                self.imageUrl = extractMetaTagContent(from: html, with: "og:image").flatMap { URL(string: $0) }
                self.title = extractMetaTagContent(from: html, with: "og:title") ?? "No Title"
            }
        }.resume()
    }
    
    private func extractMetaTagContent(from html: String, with property: String) -> String? {
        guard let startRange = html.range(of: "<meta property=\"\(property)\" content=\"") else {
            return nil
        }
        let contentStartIndex = html.index(startRange.upperBound, offsetBy: 0)
        guard let endRange = html[contentStartIndex...].range(of: "\"") else {
            return nil
        }
        let content = String(html[contentStartIndex..<endRange.lowerBound])
        return content
    }
}



struct SafariView: View {
    var url: URL
    
    var body: some View {
        SafariViewControllerWrapper(url: url)
            .edgesIgnoringSafeArea(.all)
    }
}

struct SafariViewControllerWrapper: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

#Preview {
    BenefitView(organ: .constant(Organ(name: "Polmoni", image: "polmoni", articles: [
        Article(title: "Articolo 1", url: URL(string: "https://www.sbmedical.it/blog/smettere-di-fumare-puo-salvare-il-cuore-ecco-perche/")!),
        Article(title: "Articolo 2", url: URL(string: "https://example.com/article2")!),
        Article(title: "Articolo 3", url: URL(string: "https://example.com/article3")!)
    ])))
}
