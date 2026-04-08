//
//  AIChatUIView.swift
//  SweetBites
//
//  Created by Turma01-9 on 01/04/26.
//

import SwiftUI

struct AIChatUIView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
        ZStack {
            Color.brancoFumaca
                .ignoresSafeArea()
            
            VStack {
                // Header
                Text("Chef AI 🧑‍🍳")
                    .font(.title2)
                    .bold()
                    .padding()
                
                // Lista de Mensagens
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(viewModel.messages) { msg in
                                ChatBubble(message: msg)
                            }
                            
                            if viewModel.isTyping {
                                ProgressView()
                                    .padding()
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
                
                // Campo de Input
                HStack {
                    TextField("Pergunte ao Chef...", text: $viewModel.input)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(25)
                        .shadow(color: .gray.opacity(0.1), radius: 3)
                    
                    Button(action: viewModel.sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(viewModel.input.isEmpty ? Color.gray : Color.pink)
                            .clipShape(Circle())
                    }
                    .disabled(viewModel.input.isEmpty)
                }
                .padding()
            }
        }
    }
}

// Componente de Bolha de Mensagem
struct ChatBubble: View {
    let message: Mensagem
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.text)
                .padding()
                .background(message.isUser ? Color.pink : Color.white)
                .foregroundColor(message.isUser ? .white : .black)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.05), radius: 2)
            
            if !message.isUser { Spacer() }
        }
    }
}

#Preview {
    AIChatUIView()
}
