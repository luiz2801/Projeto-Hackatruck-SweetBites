//
//  ProfileUIView.swift
//  SweetBites
//
//  Created by Turma01-9 on 01/04/26.
//

import SwiftUI

struct ProfileUIView: View {
    
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var recipesViewModel = RecipesViewModel()
    let usr: String = "Chef"
    
    // MARK: - Listagem de Receitas
    @State private var minhasReceitas: [Recipes] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.brancoFumaca
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Título do Perfil
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
                        
                        // MARK: - Área do Usuário (Chef)
                        HStack(alignment: .top, spacing: 15) {
                            
                            AsyncImage(url: URL(string: "https://universodenegocios.com.br/wp-content/uploads/2023/03/COOKER.jpg")) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 6) {
                                let nomeExibicao = userViewModel.users.first?.user_name ?? "Chef"
                                let bioExibicao = userViewModel.users.first?.user_description ?? "Criador das receitas brutais e clássicas do SweetBites."
                                
                                Text(nomeExibicao)
                                    .font(.title2)
                                    .bold()
                                
                                Text(bioExibicao)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.top, 5)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.vertical, 10)
                        
                        // MARK: - Cabeçalho Minhas Receitas
                        HStack {
                            Text("Minhas Receitas")
                                .font( .title3)
                                .bold()
                            
                            Spacer()
                            
                            // Altere 'AddRecipeView()' para o nome da sua tela de criação
                            NavigationLink(destination: Text("Tela de Adicionar Receita")) {
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
                        
                        // MARK: - Lista de Cards
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
                                NavigationLink(destination: RecipeView(recipe: receita)) {
                                    HStack(alignment: .top, spacing: 15) {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(10)
                                            .overlay(
                                                Group {
                                                    if let urlStr = receita.recipe_image_url, let url = URL(string: urlStr) {
                                                        AsyncImage(url: url) { img in
                                                            img.resizable()
                                                               .scaledToFill()
                                                        } placeholder: {
                                                            ProgressView()
                                                        }
                                                    } else {
                                                        Image(systemName: "photo")
                                                            .foregroundColor(.gray)
                                                    }
                                                }
                                            )
                                            .clipped()
                                        
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(receita.recipe_name ?? "Sem nome")
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                                .multilineTextAlignment(.leading)
                                            
                                            Text(receita.recipe_description ?? "Sem descrição")
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
                    recipesViewModel.fetch()
                }
                .onReceive(recipesViewModel.$recipes) { novasReceitas in
                    // Filtra o array para manter apenas as receitas onde o user_name bate com a variável usr
                    self.minhasReceitas = novasReceitas.filter { $0.user_name == self.usr }
                }
    }
}

#Preview {
    ProfileUIView()
}
