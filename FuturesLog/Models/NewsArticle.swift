import Foundation

struct NewsArticle: Identifiable {
    let id = UUID()
    let source: String
    let title: String
    let description: String
    let url: String
    let publishedAt: Date
} 