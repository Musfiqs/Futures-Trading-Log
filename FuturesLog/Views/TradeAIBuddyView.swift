import SwiftUI

struct TradeAIBuddyView: View {
    @EnvironmentObject var viewModel: AIBuddyViewModel
    @State private var messageText = ""
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.messages) { message in
                                    MessageBubble(message: message)
                                }
                            }
                            .padding()
                        }
                        .onChange(of: viewModel.messages.count) { oldValue, newValue in
                            withAnimation {
                                proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Quick Prompts
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.quickPrompts, id: \.self) { prompt in
                                QuickPromptButton(title: prompt) {
                                    sendMessage(prompt)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    // Message Input
                    HStack(spacing: 12) {
                        TextField("Ask TradeAI Buddy...", text: $messageText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, 8)
                        
                        Button(action: {
                            sendMessage(messageText)
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title2)
                                .foregroundColor(messageText.isEmpty ? AppTheme.secondaryText : AppTheme.accent)
                        }
                        .disabled(messageText.isEmpty)
                    }
                    .padding()
                }
            }
            .navigationTitle("TradeAI Buddy")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gear")
                            .font(.title3)
                            .foregroundColor(AppTheme.text)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
    
    private func sendMessage(_ text: String) {
        guard !text.isEmpty else { return }
        viewModel.sendMessage(text)
        messageText = ""
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding()
                    .background(message.isUser ? AppTheme.accent : AppTheme.cardBackground)
                    .foregroundColor(message.isUser ? .white : AppTheme.text)
                    .cornerRadius(16)
                
                Text(message.timestamp.formatted(.dateTime.hour().minute()))
                    .font(.caption2)
                    .foregroundColor(AppTheme.secondaryText)
            }
            
            if !message.isUser {
                Spacer()
            }
        }
    }
}

struct QuickPromptButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(AppTheme.cardBackground)
                .foregroundColor(AppTheme.text)
                .cornerRadius(20)
        }
    }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var apiKey = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                Form {
                    Section(header: Text("OpenAI Configuration")) {
                        SecureField("API Key", text: $apiKey)
                        Text("Your API key is stored securely in the keychain")
                            .font(.caption)
                            .foregroundColor(AppTheme.secondaryText)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // TODO: Save API key to keychain
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    TradeAIBuddyView()
        .environmentObject(AIBuddyViewModel())
} 