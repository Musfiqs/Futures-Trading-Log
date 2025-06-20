import Foundation
import SwiftUI

class TradeStore: ObservableObject {
    @Published var trades: [Trade] = []
    @Published var filteredTrades: [Trade] = []
    
    private let saveKey = "SavedTrades"
    
    init() {
        loadTrades()
    }
    
    func addTrade(_ trade: Trade) {
        trades.insert(trade, at: 0)
        saveTrades()
    }
    
    func updateTrade(_ trade: Trade) {
        if let index = trades.firstIndex(where: { $0.id == trade.id }) {
            trades[index] = trade
            saveTrades()
        }
    }
    
    func deleteTrade(_ trade: Trade) {
        trades.removeAll { $0.id == trade.id }
        saveTrades()
    }
    
    func filterTrades(by searchText: String, session: TradingSession? = nil, outcome: TradeOutcome? = nil) {
        filteredTrades = trades.filter { trade in
            let matchesSearch = searchText.isEmpty || 
                trade.title.localizedCaseInsensitiveContains(searchText) ||
                trade.ticker.localizedCaseInsensitiveContains(searchText) ||
                trade.reflection.localizedCaseInsensitiveContains(searchText) ||
                trade.tags.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
            
            let matchesSession = session == nil || trade.session == session
            let matchesOutcome = outcome == nil || trade.outcome == outcome
            
            return matchesSearch && matchesSession && matchesOutcome
        }
    }
    
    // MARK: - Persistence
    private func saveTrades() {
        if let encoded = try? JSONEncoder().encode(trades) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadTrades() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Trade].self, from: data) {
            trades = decoded
            filteredTrades = decoded
        }
    }
    
    // MARK: - Statistics
    func getTodaysTrades() -> [Trade] {
        let calendar = Calendar.current
        return trades.filter { calendar.isDateInToday($0.date) }
    }
    
    func getWinLossRatio() -> (wins: Int, losses: Int) {
        let wins = trades.filter { $0.outcome == .win }.count
        let losses = trades.filter { $0.outcome == .loss }.count
        return (wins, losses)
    }
} 