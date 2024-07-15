import SwiftUI
import WebKit
import LinkPresentation

struct BenefitView: View {
    @Binding var organ: Organ
    @State private var selectedArticle: Article?
    @State private var isSheetPresented = false
    
    var body: some View {
        VStack {
            Image(organ.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
            
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
                                    .padding(.horizontal)
                                    .padding(.vertical, 2)
                            }
                        }
            
            Spacer()
        }
        .navigationTitle("Benefici su \(organ.name)")
        .sheet(isPresented: $isSheetPresented) {
            if let article = selectedArticle {
                ArticleView(article: article)
            }
        }
    }
}

struct ArticleView: View {
    var article: Article
    
    var body: some View {
        WebView(url: article.url)
            .navigationTitle(article.title)
            .navigationBarTitleDisplayMode(.inline)
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
        Article(title: "Articolo 1", url: URL(string: "https://www.salute.gov.it/portale/fumo/dettaglioContenutiFumo.jsp?lingua=italiano&id=5579&area=fumo&menu=vuoto#:~:text=Il%20fumo%20di%20tabacco%2C%20in,di%20cancro%2C%20cardiopatie%2C%20vasculopatie.")!),
        Article(title: "Articolo 2", url: URL(string: "https://example.com/article2")!),
        Article(title: "Articolo 3", url: URL(string: "https://example.com/article3")!)
    ])))
}

