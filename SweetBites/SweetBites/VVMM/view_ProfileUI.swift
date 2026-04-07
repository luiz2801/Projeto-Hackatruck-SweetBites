//
//  ProfileUIView.swift
//  SweetBites
//
//  Created by Turma01-9 on 01/04/26.
//

import SwiftUI

struct ProfileUIView: View {
    
    @StateObject private var userViewModel = UserViewModel()
    
    // Mock
    @State private var minhasReceitas: [Recipes] = [
        Recipes(id: "123", rev: nil, recipe_name: "Bolo de Cenoura", user_name: "Chef", recipe_image_url: nil, recipe_description: "Aquele bolo clássico.", ingredients: ["Cenoura"], preparation_method: "Asse por 40 min.", preparation_time: 40, category: [1], upvote: 10, downvote: 0, comments: [], save_counter: 5)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.brancoFumaca
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .center) {
                            Text("Meu Perfil")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            Text("SweetBites")
                                .font(.title)
                                .bold()
                                .foregroundColor(.pink)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                        
                        HStack(alignment: .top, spacing: 15) {
                            
                            Image("Eu")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 6) {
                                if userViewModel.users.isEmpty {
                                    ProgressView()
                                        .padding(.top, 10)
                                } else if let usuarioAtual = userViewModel.users.first {
                                    // pega do banco de dados
                                    Text(usuarioAtual.user_name ?? "Sem Nome")
                                        .font(.title2)
                                        .bold()
                                    
                                    Text(usuarioAtual.user_description ?? "Nenhuma bio disponível.")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            .padding(.top, 5)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.vertical, 10)
                        
                        HStack {
                            Text("Minhas Receitas")
                                .font(.title3)
                                .bold()
                            
                            Spacer()
                            
                            NavigationLink(destination: AddRecipeUIView()) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Nova")
                                }
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.pink)
                                .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                        
                        if minhasReceitas.isEmpty {
                            VStack(alignment: .center, spacing: 10) {
                                Image(systemName: "text.book.closed")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray.opacity(0.5))
                                
                                Text("Você ainda não adicionou nenhuma receita.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)
                            
                        } else {
                            ForEach(minhasReceitas) { receita in
                                NavigationLink(destination: view_recipe(recipe: receita)) {
                                    HStack(alignment: .top, spacing: 15) {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(10)
                                            .overlay(Image(systemName: "photo").foregroundColor(.gray))
                                        
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(receita.recipe_name ?? "Sem nome")
                                                .font(.headline)
                                                .multilineTextAlignment(.leading)
                                            
                                            Text(receita.preparation_method ?? "")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.leading)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom, 10)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .onAppear {
            userViewModel.fetch()
        }
    }
}

#Preview {
    ProfileUIView()
}
