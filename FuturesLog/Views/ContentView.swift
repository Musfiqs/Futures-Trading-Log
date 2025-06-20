import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            TradeAIBuddyView()
                .tabItem {
                    Label("AI Buddy", systemImage: "brain.head.profile")
                }
                .tag(2)
        }
        .accentColor(AppTheme.accent)
    }
}

struct HomeView: View {
    @EnvironmentObject var tradeStore: TradeStore
    @State private var showingNewTrade = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        DailySummaryView()
                        
                        RecentTradesView()
                    }
                    .padding()
                }
            }
            .navigationTitle("FuturesLog")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewTrade = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(AppTheme.accent)
                    }
                }
            }
            .sheet(isPresented: $showingNewTrade) {
                NewTradeView()
            }
        }
    }
}

struct DailySummaryView: View {
    @EnvironmentObject var tradeStore: TradeStore
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Today's Summary")
                .font(.headline)
                .foregroundColor(AppTheme.text)
            
            HStack(spacing: 20) {
                StatCard(title: "Trades", value: "\(tradeStore.getTodaysTrades().count)")
                
                let ratio = tradeStore.getWinLossRatio()
                StatCard(title: "Win/Loss", value: "\(ratio.wins)/\(ratio.losses)")
            }
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(AppTheme.secondaryText)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.text)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(AppTheme.background)
        .cornerRadius(8)
    }
}

struct RecentTradesView: View {
    @EnvironmentObject var tradeStore: TradeStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Trades")
                .font(.headline)
                .foregroundColor(AppTheme.text)
            
            ForEach(tradeStore.trades.prefix(5)) { trade in
                NavigationLink(destination: TradeDetailView(trade: trade)) {
                    TradeRowView(trade: trade)
                }
            }
        }
    }
}

struct TradeRowView: View, Equatable {
    let trade: Trade
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(trade.title)
                    .font(.headline)
                    .foregroundColor(AppTheme.text)
                
                Text(trade.ticker)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.secondaryText)
            }
            
            Spacer()
            
            Circle()
                .fill(trade.outcome.color)
                .frame(width: 12, height: 12)
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ContentView()
        .environmentObject(TradeStore())
        .environmentObject(AIBuddyViewModel())
} 