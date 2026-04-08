//
//  FeedUIView.swift
//  SweetBites
//
//  Created by Turma01-9 on 01/04/26.
//

import SwiftUI


struct FeedUIView: View {
    @StateObject private var viewModel = RecipesViewModel()
    
    var body: some View {
        // Envolve tudo em um NavigationStack para permitir transições de tela
        NavigationStack {
            ZStack{
                Color.brancoFumaca
                    .ignoresSafeArea()
                
                ScrollView{
                    VStack(spacing: 16){
                        if viewModel.recipes.isEmpty {
                            ProgressView("Carregando receitas...")
                                .padding(.top, 50)
                        } else {
                            ForEach(viewModel.recipes) { recipe in
                                // NavigationLink transforma o card em um botão clicável
                                NavigationLink(destination: view_recipe(recipe: recipe)) {
                                    RecipeCardView(recipe: recipe)
                                }
                                // Remove o estilo de botão padrão que deixa o texto azul
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Feed de Receitas") // Título no topo do Feed
            .onAppear {
                viewModel.fetch()
            }
        }
    }
}

// Subcomponente para exibir cada receita individualmente
struct RecipeCardView: View {
    let recipe: Recipes
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // Tenta carregar a imagem da receita
            if let imageUrlString = recipe.recipe_image_url, let url = URL(string: imageUrlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .clipped()
                            .cornerRadius(10)
                    case .failure:
                        Image(systemName: "photo")
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            // Título e Autor
            Text(recipe.recipe_name ?? "Receita sem título")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Por: \(recipe.user_name ?? "Usuário desconhecido")")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Descrição
            Text(recipe.recipe_description ?? "Sem descrição disponível.")
                .font(.body)
                .lineLimit(3)
                .foregroundColor(.primary)
            
            // Rodapé do Card (Upvotes e Tempo)
            HStack {
                // Cálculo do delta de upvote e downvote
                let upvotes = recipe.upvote ?? 0
                let downvotes = recipe.downvote ?? 0
                let totalVotes = upvotes - downvotes
                
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.heart.fill")
                        .foregroundColor(.red)
                    Text("\(totalVotes)")
                }
                
                Spacer()
                
                if let time = recipe.preparation_time {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text("\(time) min")
                    }
                }
            }
            .font(.caption)
            .foregroundColor(.gray)
            .padding(.top, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    FeedUIView()
}
