//
//  model_gemini.swift
//  SweetBites
//
//  Created by Turma01-16 on 01/04/26.
//

import SwiftUI
import GoogleGenerativeAI
import Combine

// 1. Adicionado o molde da Mensagem que estava faltando
struct Mensagem: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

// 2. Mudou de 'struct' para 'class', e adicionou ObservableObject
class modelo: ObservableObject {
    
    // 3. Adicionado as variáveis que estavam dando erro de "Cannot find in scope"
    @Published var input: String = ""
    @Published var messages: [Mensagem] = []
    
    let model = GenerativeModel(
        name: "gemini-2.5-flash",
        apiKey: APIKey.default,
        systemInstruction: ModelContent(role: "system", parts: [
            .text("Você é um professor de gastronomia.")
        ])
    )
    
    func sendMessage() {
        let userText = input
        guard !userText.isEmpty else { return }
        
        // 1. Atualiza a UI local com a mensagem do usuário imediatamente
        messages.append(Mensagem(text: userText, isUser: true))
        input = "" // Limpa o campo de entrada
        
        // 2. Inicia uma tarefa assíncrona para não travar a interface
        Task {
            do {
                // CORREÇÃO: Tirei o "tutor de idiomas" que estava conflitando com o professor de gastronomia
                let response = try await model.generateContent(userText)
                
                if let responseText = response.text {
                    // Retorna para a Main Thread para atualizar a interface com a resposta
                    await MainActor.run {
                        messages.append(Mensagem(text: responseText, isUser: false))
                    }
                }
            } catch {
                // Tratamento básico de erro de conexão ou API
                print(" ERRO DO GEMINI: \(error)")
                print(" DESCRIÇÃO: \(error.localizedDescription)")
                await MainActor.run {
                    messages.append(Mensagem(text: "Erro: Não consegui conectar com o professor.", isUser: false))
                }
            }
        }
    }

        func limparChat() {
            messages.removeAll()
            input = ""
        }
    
}
