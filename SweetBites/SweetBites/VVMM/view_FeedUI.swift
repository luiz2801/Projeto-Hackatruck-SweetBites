//
//  FeedUIView.swift
//  SweetBites
//

import SwiftUI

struct FeedUIView: View {
    @StateObject private var viewModel = RecipesViewModel()
    let user_id: String = "e5a0d91f78505a60b4034c803015cf56"
    
    // Propriedade computada para ordenar as receitas do maior para o menor saldo de votos
    var sortedRecipes: [Recipes] {
        viewModel.recipes.sorted {
            let scoreA = ($0.upvote?.count ?? 0) - ($0.downvote?.count ?? 0)
            let scoreB = ($1.upvote?.count ?? 0) - ($1.downvote?.count ?? 0)
            return scoreA > scoreB
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.brancoFumaca // Certifique-se de que essa cor esteja no seu Asset/Extension
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        if viewModel.recipes.isEmpty {
                            ProgressView("Carregando receitas...")
                                .padding(.top, 50)
                        } else {
                            // Usando o array ordenado aqui
                            ForEach(sortedRecipes) { recipe in
                                NavigationLink(destination: RecipeView(recipe: recipe)) {
                                    RecipeCardView(
                                        recipe: recipe,
                                        onUpvote: { vote(recipe: recipe, isUpvote: true, user_id: user_id) },
                                        onDownvote: { vote(recipe: recipe, isUpvote: false, user_id: user_id) }
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding()
                }
                .refreshable {
                    viewModel.fetch()
                }
            }
            .navigationTitle("Feed de Receitas")
            .onAppear {
                viewModel.fetch()
            }
        }
    }
    
    // Função para lidar com os votos e atualizar a API
    private func vote(recipe: Recipes, isUpvote: Bool, user_id: String) {
        var updatedRecipe: Recipes = recipe
        var isUpdated = false
        
        if recipe.upvote?.contains(user_id) == false && isUpvote {
            updatedRecipe.upvote?.append(user_id)
            isUpdated = true
        }
        else if recipe.downvote?.contains(user_id) == false && isUpvote == false {
            updatedRecipe.downvote?.append(user_id)
            isUpdated = true
        }
        
        if isUpdated {
            viewModel.put(recipe: recipe)
            viewModel.fetch()
        }
    }
}

// Subcomponente para exibir cada receita individualmente
struct RecipeCardView: View {
    let recipe: Recipes
    var onUpvote: () -> Void    // Ação para o upvote
    var onDownvote: () -> Void  // Ação para o downvote
    
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
                let upvotes = recipe.upvote?.count ?? 0
                let downvotes = recipe.downvote?.count ?? 0
                let totalVotes = upvotes - downvotes
                
                HStack(spacing: 12) {
                    // Botão de Upvote (Usando onTapGesture para não conflitar com o NavigationLink)
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                        .onTapGesture {
                            onUpvote()
                        }
                    
                    Text("\(totalVotes)")
                        .fontWeight(.bold)
                    
                    // Botão de Downvote
                    Image(systemName: "arrow.down.circle.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                        .onTapGesture {
                            onDownvote()
                        }
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
