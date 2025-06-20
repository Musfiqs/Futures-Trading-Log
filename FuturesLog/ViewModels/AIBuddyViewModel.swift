import Foundation

struct Message: Identifiable, Codable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date
    
    init(id: UUID = UUID(), content: String, isUser: Bool, timestamp: Date = Date()) {
        self.id = id
        self.content = content
        self.isUser = isUser
        self.timestamp = timestamp
    }
}

class AIBuddyViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isTyping = false
    
    private let openAIKey: String? = nil // Set this via settings
    private let saveKey = "SavedMessages"
    
    init() {
        loadMessages()
    }
    
    func sendMessage(_ content: String) {
        let userMessage = Message(content: content, isUser: true)
        messages.append(userMessage)
        isTyping = true
        
        // TODO: Implement OpenAI API call
        // For now, simulate response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.receiveMessage("I'm your TradeAI Buddy! I'll help analyze your trades once you configure the OpenAI API key in settings.")
        }
    }
    
    func receiveMessage(_ content: String) {
        let aiMessage = Message(content: content, isUser: false)
        messages.append(aiMessage)
        isTyping = false
        saveMessages()
    }
    
    // MARK: - Persistence
    private func saveMessages() {
        if let encoded = try? JSONEncoder().encode(messages) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadMessages() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Message].self, from: data) {
            messages = decoded
        }
    }
    
    // MARK: - Quick Prompts
    let quickPrompts = [
        "Why did I lose this trade?",
        "How do I improve my R:R?",
        "How should I have played this setup?",
        "What kind of mindset should I keep?",
        "Analyze my trading pattern",
        "Help me with risk management"
    ]
} 