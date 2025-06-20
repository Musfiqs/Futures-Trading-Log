import Foundation

@MainActor
class NewsViewModel: ObservableObject {
    @Published var articles: [NewsArticle] = []
    @Published var suggestions = ["Market Sentiment", "Geopolitics", "FOMC", "Inflation", "Crypto"]
    @Published var isLoading = false
    
    func searchNews(query: String) async {
        isLoading = true
        // Simulate a network request
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        self.articles = [
            NewsArticle(source: "Bloomberg", title: "Powell Signals Fed Prepared to Move Faster on Inflation", description: "Federal Reserve Chair Jerome Powell signaled the U.S. central bank is prepared to raise interest rates in half-percentage point steps if necessary...", url: "https://bloomberg.com", publishedAt: Date().addingTimeInterval(-3600)),
            NewsArticle(source: "Reuters", title: "Oil prices drop on demand concerns as China lockdowns bite", description: "Oil prices fell on Tuesday, on concerns that new COVID-19 lockdowns in China will hit demand, but the downside was capped by a tighter market as the European Union weighs a ban on Russian oil.", url: "https://reuters.com", publishedAt: Date().addingTimeInterval(-7200)),
            NewsArticle(source: "Associated Press", title: "Stocks rally as tech giants lead the way", description: "A broad rally on Wall Street pushed stocks higher Thursday, as the market clawed back more of the ground it lost in a miserable few weeks of trading.", url: "https://apnews.com", publishedAt: Date().addingTimeInterval(-10800)),
            NewsArticle(source: "The Wall Street Journal", title: "U.S. Inflation Hit 8.5% in March, Highest Since 1981", description: "The consumer-price index's rise to a new four-decade high is putting pressure on the Federal Reserve to raise interest rates even more aggressively.", url: "https://wsj.com", publishedAt: Date().addingTimeInterval(-14400))
        ]
        isLoading = false
    }
    
    init() {
        Task {
            await searchNews(query: "")
        }
    }
} 