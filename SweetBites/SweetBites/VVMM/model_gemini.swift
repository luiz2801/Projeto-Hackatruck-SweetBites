//
//  model_gemini.swift
//  SweetBites
//
//  Created by Turma01-16 on 01/04/26.
//

import SwiftUI
import GoogleGenerativeAI

struct modelo{
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
                // Envia o prompt para o Gemini com uma instrução de "persona" (Tutor)
                let response = try await model.generateContent("Você é um tutor de idiomas. Responda brevemente a isto: \(userText)")
                
                if let responseText = response.text {
                    // Retorna para a Main Thread para atualizar a interface com a resposta
                    await MainActor.run {
                        messages.append(Mensagem(text: responseText, isUser: false))
                    }
                }
            } catch {
                // Tratamento básico de erro de conexão ou API
                await MainActor.run {
                    messages.append(Mensagem(text: "Erro: Não consegui conectar com o tutor.", isUser: false))
                }
            }
        }
    }

}
