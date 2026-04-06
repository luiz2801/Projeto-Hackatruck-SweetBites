//
//  MessageBubbleView.swift
//  SweetBites
//
//  Created by Turma01-9 on 06/04/26.
//

import SwiftUI

struct MessageBubbleView: View {
    let mensagem: Mensagem 
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            // Se a mensagem é do user, fica na direita
            if mensagem.isUser {
                Spacer(minLength: 40)
                Text(mensagem.text)
                    .padding(14)
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            // Se a mensagem é da IA fica na esquerda
            } else {
               
                Image(systemName: "sparkles")
                    .foregroundColor(.pink)
                    .font(.title3)
                
                Text(mensagem.text)
                    .padding(14)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .shadow(color: .gray.opacity(0.1), radius: 3)
                Spacer(minLength: 40) // Empurra para a esquerda
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // isUser = true
        MessageBubbleView(mensagem: Mensagem(text: "TESTANDO 1,2,3...", isUser: true))
        
        // isUser = false
        MessageBubbleView(mensagem: Mensagem(text: "TESTADO 1,2,3...", isUser: false))
    }
    .padding()
    .background(Color(white: 0.96))
}
