//
//  CategoriaButtom.swift
//  SweetBites
//
//  Created by Turma01-9 on 01/04/26.
//

import Foundation

import SwiftUI

struct CategoriaButton: View {
    var titulo: String
    @Binding var isSelected: Bool
    
    var corSelecionado: Color = .red
    var corBorda: Color = .pink
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            Text(titulo)
                .font(.subheadline)
                .bold()
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .foregroundStyle(isSelected ? .white : corBorda)
                .background(isSelected ? corSelecionado : Color.white)
                .overlay(
                    Capsule().stroke(corBorda, lineWidth: 1)
                )
                .clipShape(Capsule())
        }
    }
}
