//
//  InputBarView.swift
//  SweetBites
//
//  Created by Turma01-9 on 06/04/26.
//

import SwiftUI

struct InputBarView: View {
    @ObservedObject var geminiModel: modelo
    
    var body: some View {
        HStack(spacing: 12) {
            TextField("Ex: Tenho ovos, farinha e chocolate...", text: $geminiModel.input)
                .padding(12)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .gray.opacity(0.1), radius: 3)
                .onSubmit {
                    geminiModel.sendMessage()
                }
            
            Button(action: {
                geminiModel.sendMessage()
            }) {
                Image(systemName: "paperplane.fill")
                    .font(.title2)
                    .foregroundColor(geminiModel.input.isEmpty ? .gray.opacity(0.5) : .pink)
            }
            .disabled(geminiModel.input.isEmpty)
        }
        .padding()
        .background(Color.brancoFumaca)
    }
}
