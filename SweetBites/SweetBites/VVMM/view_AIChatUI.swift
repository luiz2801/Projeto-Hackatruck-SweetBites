//
//  AIChatUIView.swift
//  SweetBites
//
//  Created by Turma01-9 on 01/04/26.
//

// FALTA AJUSTAR A API DO GEMINI, AINDA NAO DEVOLVE A MENSAGEM DO GEMINI

import SwiftUI

struct AIChatUIView: View {
    @StateObject private var geminiModel = modelo()
    
    var body: some View {
        ZStack{
            Color.brancoFumaca
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                HStack{
                    Spacer()
                    
                    Text("CHEF IA")
                        .font(.title3)
                        .bold()
                        .padding(.leading, 24)
                    
                    Spacer()
                    
                    CircularIconButton(iconName: "trash", cor: .pink){
                        withAnimation{
                            geminiModel.limparChat()
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollViewReader{ proxy in
                    ScrollView{
                        VStack(spacing: 15){
                            if geminiModel.messages.isEmpty{
                                WelcomeMessageView()
                            }
                            
                            ForEach(geminiModel.messages){ mensagem in
                                MessageBubbleView(mensagem: mensagem)
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                            .padding(.bottom, 20)
                        }
                        
                        .onChange(of: geminiModel.messages.count){
                            if let lastMessage = geminiModel.messages.last{
                                withAnimation{
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                InputBarView(geminiModel: geminiModel)
            }
        }
    }
}

#Preview {
    AIChatUIView()
}
