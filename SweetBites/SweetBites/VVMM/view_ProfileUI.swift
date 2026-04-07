//
//  ProfileUIView.swift
//  SweetBites
//
//  Created by Turma01-9 on 01/04/26.
//

import SwiftUI

struct ProfileUIView: View {
    var body: some View {
        ZStack{
            Color.brancoFumaca
                .ignoresSafeArea()
            ScrollView{
                VStack{
                    Text("Perfil")
                        .font(.title)
                        .bold()
                    Text("SweetBites")
                        .font(.title)
                        .bold()
                    HStack{
                        Image("Eu")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 120, height: 120)
                            .padding()
                        Spacer()
                        Text("Maria Rita")
                            .padding()
                       
                    }
                    Text("Receita")
                    Rectangle()
                        .frame(width: 300, height: 100)
                    Text("Modo de preparo")
                    Rectangle()
                        .frame(width: 300, height: 100)
                    Text("Categoria: Doce")
                    Text("Receita")
                    Rectangle()
                        .frame(width: 300, height: 100)
                    Text("Modo de preparo")
                    Rectangle()
                        .frame(width: 300, height: 100)
                    Text("Categoria: Refeição")

                    
                
                }
            }
        }
    }
}

#Preview {
    ProfileUIView()
}
