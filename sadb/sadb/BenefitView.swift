import SwiftUI
import WebKit
import LinkPresentation

struct BenefitView: View {
    @Binding var organ: Organ
    @State private var selectedArticle: Article?
    @State private var isSheetPresented = false
    
    var body: some View {
        ScrollView{
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
                        LinkPreviewView(url: article.url)
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
                        ArticleView(article: article, isPresented: $isSheetPresented)
                    }
        }
    }
}

struct ArticleView: View {
    var article: Article
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            WebView(url: article.url)
                .navigationTitle(article.title)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button(action: {
                    isPresented = false
                }) {
                    Text("Fine")
                })
        }
    }
}

struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct LinkPreviewView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> LPLinkView {
        let view = LPLinkView(url: url)
        let provider = LPMetadataProvider()
        
        provider.startFetchingMetadata(for: url) { metadata, error in
            if let metadata = metadata {
                DispatchQueue.main.async {
                    view.metadata = metadata
                }
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: LPLinkView, context: Context) {}
}

#Preview {
    BenefitView(organ: .constant(Organ(name: "Polmoni", image: "polmoni", articles: [
        Article(title: "Articolo 1", url: URL(string: "https://www.sbmedical.it/blog/smettere-di-fumare-puo-salvare-il-cuore-ecco-perche/")!),
        Article(title: "Articolo 2", url: URL(string: "https://example.com/article2")!),
        Article(title: "Articolo 3", url: URL(string: "https://example.com/article3")!)
    ])))
}

