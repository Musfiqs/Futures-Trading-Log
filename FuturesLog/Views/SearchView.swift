import SwiftUI

struct SearchView: View {
    @StateObject private var newsViewModel = NewsViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    searchBar
                        .padding()
                    
                    suggestionChips
                        .padding(.bottom, 8)
                    
                    if newsViewModel.isLoading {
                        Spacer()
                        ProgressView()
                        Spacer()
                    } else {
                        newsList
                    }
                }
            }
            .navigationTitle("News & Search")
            .onChange(of: searchText) {
                Task {
                    await newsViewModel.searchNews(query: searchText)
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppTheme.secondaryText)
            
            TextField("Search for news...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppTheme.secondaryText)
                }
            }
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var suggestionChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(newsViewModel.suggestions, id: \.self) { suggestion in
                    Button(action: {
                        searchText = suggestion
                    }) {
                        Text(suggestion)
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(AppTheme.accent.opacity(0.2))
                            .foregroundColor(AppTheme.accent)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var newsList: some View {
        List(newsViewModel.articles) { article in
            NewsArticleRow(article: article)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowSeparator(.hidden)
                .listRowBackground(AppTheme.background)
        }
        .listStyle(PlainListStyle())
        .refreshable {
            await newsViewModel.searchNews(query: searchText)
        }
    }
}

struct NewsArticleRow: View {
    let article: NewsArticle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(article.source)
                .font(.caption)
                .foregroundColor(AppTheme.secondaryText)
            
            Text(article.title)
                .font(.headline)
                .foregroundColor(AppTheme.text)
            
            Text(article.description)
                .font(.subheadline)
                .foregroundColor(AppTheme.secondaryText)
                .lineLimit(2)
            
            Text(article.publishedAt, style: .time)
                .font(.caption2)
                .foregroundColor(AppTheme.secondaryText)
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    SearchView()
} 