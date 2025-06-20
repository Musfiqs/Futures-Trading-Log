import Foundation
import SwiftUI

struct Trade: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var date: Date
    var ticker: String
    var outcome: TradeOutcome
    var rating: Int // 1-5 stars
    var reflection: String
    var tags: [String]
    var imageURLs: [URL]
    var emotion: TradeEmotion
    var session: TradingSession
    
    init(id: UUID = UUID(), 
         title: String = "",
         date: Date = Date(),
         ticker: String = "",
         outcome: TradeOutcome = .neutral,
         rating: Int = 3,
         reflection: String = "",
         tags: [String] = [],
         imageURLs: [URL] = [],
         emotion: TradeEmotion = .neutral,
         session: TradingSession = .ny) {
        self.id = id
        self.title = title
        self.date = date
        self.ticker = ticker
        self.outcome = outcome
        self.rating = rating
        self.reflection = reflection
        self.tags = tags
        self.imageURLs = imageURLs
        self.emotion = emotion
        self.session = session
    }
}

enum TradeOutcome: String, Codable {
    case win
    case loss
    case neutral
    case breakeven
    
    var color: Color {
        switch self {
        case .win: return AppTheme.accent
        case .loss: return .red
        case .neutral: return .gray
        case .breakeven: return .orange
        }
    }
}

enum TradeEmotion: String, Codable, CaseIterable {
    case confident
    case nervous
    case fomo
    case patient
    case frustrated
    case neutral
    
    var emoji: String {
        switch self {
        case .confident: return "😊"
        case .nervous: return "😰"
        case .fomo: return "😩"
        case .patient: return "😌"
        case .frustrated: return "😤"
        case .neutral: return "😐"
        }
    }
}

enum TradingSession: String, Codable, CaseIterable {
    case london = "London"
    case ny = "New York"
    case asia = "Asia"
    case globex = "Globex"
} 