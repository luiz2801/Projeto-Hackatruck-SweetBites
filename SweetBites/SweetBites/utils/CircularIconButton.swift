//
//  CircularIconButton.swift
//  SweetBites
//
//  Created by Turma01-9 on 06/04/26.
//

import SwiftUI

import SwiftUI

struct CircularIconButton: View {
    var iconName: String
    var cor: Color = .pink
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(cor)
                .padding(8)
                .background(cor.opacity(0.1))
                .clipShape(Circle())
        }
    }
}

#Preview {
    CircularIconButton(iconName: "trash") {
        print("Botão clicado!")
    }
}
