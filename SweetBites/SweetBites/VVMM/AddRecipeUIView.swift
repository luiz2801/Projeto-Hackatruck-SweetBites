//
//  AddRecipeUIView.swift
//  SweetBites
//
//  Created by Turma01-9 on 01/04/26.
//

import SwiftUI

struct AddRecipeUIView: View {
    var body: some View {
        ZStack{
            Color.brancoFumaca
                .ignoresSafeArea()
            ScrollView{
                VStack{
                    Text("Novas Receitas")
                        .font(.title)
                        .bold()
                }
            }
        }
    }
}

#Preview {
    AddRecipeUIView()
}
