import SwiftUI

struct TradeDetailView: View {
    @EnvironmentObject var tradeStore: TradeStore
    @Environment(\.presentationMode) var presentationMode
    @State private var isEditing = false
    
    let trade: Trade
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(trade.ticker)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Circle()
                            .fill(trade.outcome.color)
                            .frame(width: 16, height: 16)
                    }
                    
                    Text(trade.title)
                        .font(.headline)
                        .foregroundColor(AppTheme.secondaryText)
                    
                    Text(trade.date.formatted(date: .long, time: .shortened))
                        .font(.subheadline)
                        .foregroundColor(AppTheme.secondaryText)
                }
                
                // Rating
                HStack {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= trade.rating ? "star.fill" : "star")
                            .foregroundColor(index <= trade.rating ? AppTheme.accent : AppTheme.secondaryText)
                    }
                }
                
                // Session & Emotion
                HStack(spacing: 16) {
                    Label(trade.session.rawValue, systemImage: "clock")
                    Text(trade.emotion.emoji + " " + trade.emotion.rawValue.capitalized)
                }
                .font(.subheadline)
                .foregroundColor(AppTheme.secondaryText)
                
                // Tags
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(trade.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(AppTheme.accent.opacity(0.2))
                                .foregroundColor(AppTheme.accent)
                                .cornerRadius(16)
                        }
                    }
                }
                
                // Screenshots
                if !trade.imageURLs.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Screenshots")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(trade.imageURLs, id: \.self) { url in
                                    // TODO: Replace with actual image loading
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(AppTheme.cardBackground)
                                        .frame(width: 200, height: 150)
                                        .overlay(
                                            Image(systemName: "photo")
                                                .font(.largeTitle)
                                                .foregroundColor(AppTheme.secondaryText)
                                        )
                                }
                            }
                        }
                    }
                }
                
                // Reflection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Reflection")
                        .font(.headline)
                    
                    Text(trade.reflection)
                        .foregroundColor(AppTheme.text)
                }
                
                // AI Analysis Button
                Button(action: {
                    // TODO: Implement AI analysis
                }) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                        Text("Analyze with TradeAI")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.accent)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .background(AppTheme.background.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: {
                        isEditing = true
                    }) {
                        Text("Edit")
                    }
                    
                    Button(action: {
                        tradeStore.deleteTrade(trade)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditTradeView(trade: trade)
        }
    }
}

struct EditTradeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var tradeStore: TradeStore
    
    @State private var editedTrade: Trade
    
    init(trade: Trade) {
        _editedTrade = State(initialValue: trade)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Info")) {
                    TextField("Title", text: $editedTrade.title)
                    TextField("Ticker Symbol", text: $editedTrade.ticker)
                    
                    Picker("Session", selection: $editedTrade.session) {
                        ForEach(TradingSession.allCases, id: \.self) { session in
                            Text(session.rawValue).tag(session)
                        }
                    }
                }
                
                Section(header: Text("Outcome")) {
                    Picker("Result", selection: $editedTrade.outcome) {
                        Text("Win").tag(TradeOutcome.win)
                        Text("Loss").tag(TradeOutcome.loss)
                        Text("Break Even").tag(TradeOutcome.breakeven)
                        Text("Neutral").tag(TradeOutcome.neutral)
                    }
                    
                    HStack {
                        Text("Rating")
                        Spacer()
                        RatingView(rating: $editedTrade.rating)
                    }
                }
                
                Section(header: Text("Reflection")) {
                    TextEditor(text: $editedTrade.reflection)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Edit Trade")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    tradeStore.updateTrade(editedTrade)
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

#Preview {
    NavigationView {
        TradeDetailView(trade: Trade(
            title: "Sample Trade",
            ticker: "NQ",
            outcome: .win,
            rating: 4,
            reflection: "This was a great trade!",
            tags: ["Breakout", "Momentum"],
            emotion: .confident
        ))
        .environmentObject(TradeStore())
    }
} 