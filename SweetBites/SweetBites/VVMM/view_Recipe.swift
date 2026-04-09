//
//  view_receita.swift
//  SweetBites
//
//  Created by Turma01-16 on 07/04/26.
//

import SwiftUI


struct RecipeView: View {
    @StateObject var viewModel = RecipesViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var showingEditSheet = false
    
    let recipe: Recipes
    let logged_user_name = "Chef"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // ... (Seu código da imagem, cabeçalho, descrição, etc. continua igual) ...
                
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
                                .foregroundColor(.secondary)}}}
                    Divider()
                    if let description = recipe.recipe_description {
                        Text(description)
                            .font(.body)
                        .foregroundColor(.primary)}
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
                                    .font(.body)}}}}
                    if let method = recipe.preparation_method {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Modo de Preparo")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(method)
                            .font(.body)}}}
                
                
                
                
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // Validação: Só aparece se o user_name for igual ao dono da receita
                if recipe.user_name == logged_user_name {
                    Menu {
                        Button(action: {
                            // AQUI: Mudamos de um print para alterar o estado da sheet
                            showingEditSheet = true
                        }) {
                            Label("Editar", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive, action: {
                            viewModel.delete(recipe: recipe)
                            dismiss()
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
        // AQUI: Adicionamos o modificador que abre a tela de edição
        .sheet(isPresented: $showingEditSheet) {
            // Passamos a viewModel e a receita atual
            EditRecipeView(viewModel: viewModel, recipe: recipe)
        }
    }
    
}
