//
//  ChatView.swift
//  SumaConnect
//
//  Created by Alberto Orrantia on 11/12/25.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    // Focus state to control keyboard behavior, for the chat we dont want it to close each time the user taps send
    @FocusState private var isInputFocused: Bool
    @Namespace private var bottomAnchor
    
    var body: some View {
        ZStack {
            Color.Suma.darkGray
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                SumaHeaderView()
                
                // MARK: - Message list
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            Color.clear.frame(height: 20)
                            
                            ForEach(viewModel.messages) { msg in
                                ChatBubble(message: msg)
                                    .id(msg.id)
                            }
                            
                            if viewModel.isTyping {
                                TypingIndicator()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 20)
                                    .id("typing")
                            }
                            
                            Color.clear.frame(height: 1).id(bottomAnchor)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                    // The user can dismiss keyboard by scrolling down
                    .scrollDismissesKeyboard(.interactively)
                    .onChange(of: viewModel.messages) { _ in
                        withAnimation { proxy.scrollTo(bottomAnchor, anchor: .bottom) }
                    }
                    .onChange(of: viewModel.isTyping) { isTyping in
                        if isTyping { withAnimation { proxy.scrollTo("typing", anchor: .bottom) } }
                    }
                }
                
                inputBar
            }
        }
    }
    
    private var inputBar: some View {
        HStack(spacing: 12) {
            TextField("Escribe un mensaje...", text: $viewModel.inputText)
                .padding(12)
                .background(Color.white)
                .cornerRadius(20)
                .foregroundColor(.black)
                // Vinculamos el foco
                .focused($isInputFocused)
                // Configuraciones de texto limpio
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .submitLabel(.send)
                .onSubmit {
                    viewModel.sendMessage()
                    isInputFocused = true
                }
            
            Button {
                viewModel.sendMessage()
                isInputFocused = true
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(
                        viewModel.inputText.isEmpty
                        ? Color.Suma.lightBlue.opacity(0.5)
                        : Color.Suma.lightBlue
                    )
                    .clipShape(Circle())
            }
            .disabled(viewModel.inputText.isEmpty)
        }
        .padding()
        .background(Color.Suma.darkGray)
    }
}

// MARK: - Subcomponents

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.sender == .user { Spacer() }
            
            Text(.init(message.text))
                .padding(14)
                .background(
                    message.sender == .user
                    ? Color.Suma.red
                    : Color.white
                )
                .foregroundColor(message.sender == .user ? .white : .black)
                .tint(Color.Suma.lightBlue)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: message.sender == .user ? .trailing : .leading)
            
            if message.sender != .user { Spacer() }
        }
    }
}

struct TypingIndicator: View {
    @State private var blink = false
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { _ in
                Circle().frame(width: 6, height: 6)
            }
        }
        .foregroundColor(.gray)
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .opacity(blink ? 0.4 : 1)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).repeatForever()) { blink.toggle() }
        }
    }
}

#Preview {
    ChatView()
}

extension ChatMessage: Equatable {
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.id == rhs.id
    }
}
