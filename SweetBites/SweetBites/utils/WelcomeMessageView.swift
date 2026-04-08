//
//  WelcomeMessageView.swift
//  SweetBites
//
//  Created by Turma01-9 on 06/04/26.
//

import SwiftUI

struct WelcomeMessageView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 40))
                .foregroundColor(.pink)
            
            Text("Olá! Eu sou o seu Chef Virtual.")
                .font(.headline)
            
            Text("Diga quais ingredientes você tem na geladeira e eu te dou uma ideia de receita deliciosa!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding(.vertical, 50)
    }
}

#Preview {
    WelcomeMessageView()
}
