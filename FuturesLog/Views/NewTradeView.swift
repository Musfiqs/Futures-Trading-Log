import SwiftUI
import PhotosUI

struct NewTradeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var tradeStore: TradeStore
    
    @State private var trade = Trade()
    @State private var showingImagePicker = false
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var showingTagInput = false
    @State private var newTag = ""
    
    var body: some View {
        NavigationView {
            Form {
                basicInfoSection
                outcomeSection
                screenshotsSection
                tagsSection
                emotionSection
                reflectionSection
            }
            .navigationTitle("New Trade")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        tradeStore.addTrade(trade)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(trade.title.isEmpty || trade.ticker.isEmpty)
                }
            }
            .alert("Add Tag", isPresented: $showingTagInput) {
                TextField("Tag name", text: $newTag)
                Button("Add") {
                    if !newTag.isEmpty {
                        trade.tags.append(newTag)
                        newTag = ""
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
            .onChange(of: selectedItems) { _, items in
                Task {
                    var urls: [URL] = []
                    for _ in items {
                        urls.append(URL(string: "placeholder")!)
                    }
                    trade.imageURLs = urls
                }
            }
        }
    }
    
    private var basicInfoSection: some View {
        Section(header: Text("Basic Info")) {
            TextField("Title", text: $trade.title)
            TextField("Ticker Symbol", text: $trade.ticker)
            
            Picker("Session", selection: $trade.session) {
                ForEach(TradingSession.allCases, id: \.self) { session in
                    Text(session.rawValue).tag(session)
                }
            }
        }
    }
    
    private var outcomeSection: some View {
        Section(header: Text("Outcome")) {
            Picker("Result", selection: $trade.outcome) {
                Text("Win").tag(TradeOutcome.win)
                Text("Loss").tag(TradeOutcome.loss)
                Text("Break Even").tag(TradeOutcome.breakeven)
                Text("Neutral").tag(TradeOutcome.neutral)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            HStack {
                Text("Rating")
                Spacer()
                RatingView(rating: $trade.rating)
            }
        }
    }
    
    private var screenshotsSection: some View {
        Section(header: Text("Screenshots")) {
            PhotosPicker(selection: $selectedItems,
                       matching: .images) {
                Label("Add Screenshots", systemImage: "photo.on.rectangle.angled")
            }
        }
    }
    
    private var tagsSection: some View {
        Section(header: Text("Tags")) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(trade.tags, id: \.self) { tag in
                        TagView(tag: tag) {
                            trade.tags.removeAll { $0 == tag }
                        }
                    }
                    
                    Button(action: { showingTagInput = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppTheme.accent)
                    }
                }
            }
        }
    }
    
    private var emotionSection: some View {
        Section(header: Text("Emotion")) {
            Picker("How did you feel?", selection: $trade.emotion) {
                ForEach(TradeEmotion.allCases, id: \.self) { emotion in
                    Text("\(emotion.emoji) \(emotion.rawValue.capitalized)")
                        .tag(emotion)
                }
            }
        }
    }
    
    private var reflectionSection: some View {
        Section(header: Text("Reflection")) {
            TextEditor(text: $trade.reflection)
                .frame(height: 100)
        }
    }
}

struct RatingView: View {
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundColor(index <= rating ? AppTheme.accent : AppTheme.secondaryText)
                    .onTapGesture {
                        rating = index
                    }
            }
        }
    }
}

struct TagView: View {
    let tag: String
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(tag)
                .font(.subheadline)
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(AppTheme.accent.opacity(0.2))
        .foregroundColor(AppTheme.accent)
        .cornerRadius(16)
    }
}

#Preview {
    NewTradeView()
        .environmentObject(TradeStore())
} 