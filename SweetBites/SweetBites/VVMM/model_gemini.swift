//
//  model_gemini.swift
//  SweetBites
//
//  Created by Turma01-16 on 01/04/26.
//
import SwiftUI
import GoogleGenerativeAI
import Foundation
import Combine // <--- ADICIONE ESTA LINHA

struct Mensagem: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

class ChatViewModel: ObservableObject { // <--- Garanta que é uma Class
    @Published var messages: [Mensagem] = []
    @Published var input: String = ""
    @Published var isTyping: Bool = false
    
    private let model = GenerativeModel(
        name: "gemini-2.5-flash",
        apiKey: APIKey.default,
        systemInstruction: ModelContent(role: "system", parts: [
            .text("Você é o Chef SweetBites, um professor de gastronomia experiente e amigável. Seu objetivo é ajudar os usuários com receitas e técnicas culinárias.")
        ])
    )
    
    func sendMessage() {
        let userText = input
        guard !userText.isEmpty else { return }
        
        messages.append(Mensagem(text: userText, isUser: true))
        input = ""
        isTyping = true
        
        Task {
            do {
                let response = try await model.generateContent(userText)
                if let responseText = response.text {
                    await MainActor.run {
                        messages.append(Mensagem(text: responseText, isUser: false))
                        isTyping = false
                    }
                }
            } catch {
                await MainActor.run {
                    messages.append(Mensagem(text: "Erro ao conectar com o Chef.", isUser: false))
                    isTyping = false
                }
            }
        }
    }
}
