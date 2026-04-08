//
//  view_receita.swift
//  SweetBites
//
//  Created by Turma01-16 on 07/04/26.
//

import SwiftUI

struct RecipeView: View {
    // Adicionando a ViewModel para suportar as ações de deletar e editar
    @StateObject var viewModel = RecipesViewModel()
    @Environment(\.dismiss) var dismiss
    
    let recipe: Recipes
    
    // Variável em hardcode solicitada para teste
    let logged_user_name = "Chef"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                // 1. Imagem de Destaque
                if let imageUrlString = recipe.recipe_image_url, let url = URL(string: imageUrlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity, minHeight: 300)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .frame(maxWidth: .infinity, minHeight: 300)
                                .background(Color.gray.opacity(0.2))
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    // 2. Cabeçalho (Título, Autor e Tempo)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(recipe.recipe_name ?? "Receita sem título")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text("Por: \(recipe.user_name ?? "Desconhecido")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            if let time = recipe.preparation_time {
                                Label("\(time) min", systemImage: "clock")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // 3. Descrição
                    if let description = recipe.recipe_description {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    
                    // 4. Ingredientes
                    if let ingredients = recipe.ingredients, !ingredients.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Ingredientes")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            ForEach(ingredients, id: \.self) { ingredient in
                                HStack(alignment: .top) {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 6))
                                        .padding(.top, 8)
                                        .foregroundColor(.orange)
                                    Text(ingredient)
                                        .font(.body)
                                }
                            }
                        }
                    }
                    
                    // 5. Modo de Preparo
                    if let method = recipe.preparation_method {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Modo de Preparo")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(method)
                                .font(.body)
                        }
                    }
                    
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        // Adicionando o botão de três pontos na Toolbar
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // Validação: Só aparece se o user_name for igual ao logged_user_name
                if recipe.user_name == logged_user_name {
                    Menu {
                        Button(action: {
                            // Lógica para abrir tela de edição
                            print("Editar selecionado")
                        }) {
                            Label("Editar", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive, action: {
                            viewModel.delete(recipe: recipe)
                            dismiss() // Volta para a tela anterior após deletar
                        }) {
                            Label("Deletar", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 18))
                    }
                }
            }
        }
    }
}
