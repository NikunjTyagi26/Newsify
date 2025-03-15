import SwiftUI
import WebKit

import SwiftUI
import CoreData

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.managedObjectContext) private var context
    @StateObject private var savedArticles = SavedArticles(context: PersistenceController.shared.container.viewContext)

    var body: some View {
        TabView {
            HomeView(savedArticles: savedArticles, isDarkMode: $isDarkMode)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            SavedView(savedArticles: savedArticles)
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
        }
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
    }
}

// MARK: - HomeView Fetching News from API
struct HomeView: View {
    @ObservedObject var savedArticles: SavedArticles
    @StateObject private var viewModel = NewsViewModel()
    @Binding var isDarkMode: Bool

    var body: some View {
        NavigationView {
            List(viewModel.articles) { article in
                NewsCard(article: article, savedArticles: savedArticles, showDeleteButton: false)
            }
            .navigationTitle("News")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isDarkMode.toggle()  // Toggle dark mode
                    }) {
                        // Use moon icon for dark mode and sun icon for light mode
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(isDarkMode ? .white : .black)  // Adjust icon color
                    }
                }
            }
            .onAppear {
                viewModel.fetchNews()
            }
        }
    }
}

// MARK: - ViewModel for API Integration
class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    
    func fetchNews() {
        let apiKey = "100dc92ed34047ae9a941e395c664f1f"
        let urlString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(NewsResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.articles = result.articles
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
}

// MARK: - API Response Models
struct NewsResponse: Codable {
    let articles: [Article]
}

struct Article: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String?
    let urlToImage: String?
    let url: String

    // Custom initializer for Decodable
    init(id: UUID = UUID(), title: String, description: String?, urlToImage: String?, url: String) {
        self.id = id
        self.title = title
        self.description = description
        self.urlToImage = urlToImage
        self.url = url
    }

    // CodingKeys to map JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case title, description, urlToImage, url
    }

    // Implement Decodable manually to handle the `id` property
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID() // Generate a new UUID for each article
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        self.url = try container.decode(String.self, forKey: .url)
    }
}
struct NewsCard: View {
    let article: Article
    @ObservedObject var savedArticles: SavedArticles
    let showDeleteButton: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let url = article.urlToImage, let imageURL = URL(string: url) {
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                
                if let description = article.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                }
                
                NavigationLink("Read More", destination: ArticleDetailView(article: article, savedArticles: savedArticles))
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)).shadow(radius: 3))
    }
}

// MARK: - Article Detail View (WebView + Share)
struct ArticleDetailView: View {
    let article: Article
    @ObservedObject var savedArticles: SavedArticles
    @State private var isSharing = false

    var body: some View {
        VStack {
            WebView(url: URL(string: article.url)!)
                .ignoresSafeArea()

            HStack {
                Button(action: {
                    isSharing = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .padding()
                }
                .sheet(isPresented: $isSharing) {
                    ShareSheet(activityItems: [article.title, article.url])
                }

                Spacer()

                Button(action: {
                    savedArticles.saveArticle(article)
                }) {
                    Image(systemName: "bookmark")
                        .padding()
                }
            }
            .padding()
        }
    }
}

// MARK: - WebView for Article Detail
struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

// MARK: - ShareSheet (iOS Share)
struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        if let popover = controller.popoverPresentationController {
            popover.sourceView = UIApplication.shared.windows.first?.rootViewController?.view
            popover.sourceRect = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Saved Articles View
struct SavedView: View {
    @ObservedObject var savedArticles: SavedArticles
    @State private var articleToDelete: Article?

    var body: some View {
        NavigationView {
            List {
                ForEach(savedArticles.articles) { article in
                    HStack {
                        NewsCard(article: article, savedArticles: savedArticles, showDeleteButton: false)

                        Button(action: {
                            articleToDelete = article
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                }
            }
            .navigationTitle("Saved Articles")
            .alert(item: $articleToDelete) { article in
                Alert(
                    title: Text("Confirm Deletion"),
                    message: Text("Are you sure you want to delete this article?"),
                    primaryButton: .destructive(Text("Delete")) {
                        savedArticles.deleteArticle(article)
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

// MARK: - Saved Articles Model
import CoreData
import SwiftUI

class SavedArticles: ObservableObject {
    @Published var articles: [Article] = []
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchArticles()
    }

    // Save an article to Core Data
    func saveArticle(_ article: Article) {
        let newArticle = ArticleEntity(context: context)
        newArticle.id = article.id
        newArticle.title = article.title
        newArticle.descriptionText = article.description
        newArticle.urlToImage = article.urlToImage
        newArticle.url = article.url

        do {
            try context.save()
            fetchArticles() // Refresh the list
        } catch {
            print("Error saving article: \(error)")
        }
    }

    // Delete an article from Core Data
    func deleteArticle(_ article: Article) {
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", article.id as CVarArg)

        do {
            let results = try context.fetch(fetchRequest)
            if let articleToDelete = results.first {
                context.delete(articleToDelete)
                try context.save()
                fetchArticles() // Refresh the list
            }
        } catch {
            print("Error deleting article: \(error)")
        }
    }

    // Fetch articles from Core Data
    private func fetchArticles() {
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            articles = results.map { Article(id: $0.id ?? UUID(), title: $0.title ?? "", description: $0.descriptionText, urlToImage: $0.urlToImage, url: $0.url ?? "") }
        } catch {
            print("Error fetching articles: \(error)")
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
