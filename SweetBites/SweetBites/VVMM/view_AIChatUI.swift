//
//  AIChatUIView.swift
//  SweetBites
//
//  Created by Turma01-9 on 01/04/26.
//

import SwiftUI

struct AIChatUIView: View {
    @StateObject private var geminiModel = modelo()
    
    var body: some View {
        ZStack{
            Color.brancoFumaca
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                Text("CHEF IA")
                    .font(.title3)
                    .bold()
                    .padding(.vertical, 10)
                ScrollViewReader{ proxy in
                    ScrollView{
                        VStack(spacing: 15){
                            
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AIChatUIView()
}
