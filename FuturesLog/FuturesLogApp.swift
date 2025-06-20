import SwiftUI

@main
struct FuturesLogApp: App {
    @StateObject private var tradeStore = TradeStore()
    @StateObject private var aiBuddyViewModel = AIBuddyViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(tradeStore)
                .environmentObject(aiBuddyViewModel)
        }
    }
}

// MARK: - Color Theme
struct AppTheme {
    static let background = Color(hex: "F5F5F5")
    static let accent = Color(hex: "6FCF97")
    static let text = Color(hex: "1A1A1A")
    static let secondaryText = Color(hex: "6E6E6E")
    static let cardBackground = Color.white
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 