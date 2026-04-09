//
//  view_EditRecipe.swift
//  SweetBites
//

import SwiftUI

struct EditRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: RecipesViewModel
    
    let originalRecipe: Recipes
    
    @State private var recipeName: String
    @State private var recipeDescription: String
    @State private var preparationMethod: String
    @State private var preparationTime: String
    @State private var imageUrl: String
    @State private var ingredients: [String]
    
    init(viewModel: RecipesViewModel, recipe: Recipes) {
        self.viewModel = viewModel
        self.originalRecipe = recipe
        
        _recipeName = State(initialValue: recipe.recipe_name ?? "")
        _recipeDescription = State(initialValue: recipe.recipe_description ?? "")
        _preparationMethod = State(initialValue: recipe.preparation_method ?? "")
        _preparationTime = State(initialValue: recipe.preparation_time != nil ? "\(recipe.preparation_time!)" : "")
        _imageUrl = State(initialValue: recipe.recipe_image_url ?? "")
        _ingredients = State(initialValue: recipe.ingredients ?? [])
    }
    
    var body: some View {
        NavigationView {
            Form {
                // ... (O resto da sua UI do Form continua exatamente igual) ...
                Section(header: Text("Informações Básicas")) {
                    TextField("Nome da Receita", text: $recipeName)
                    TextField("URL da Imagem", text: $imageUrl)
                    TextField("Tempo de Preparo (min)", text: $preparationTime)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Descrição")) {
                    TextEditor(text: $recipeDescription)
                        .frame(minHeight: 80)
                }
                
                Section(header: Text("Ingredientes")) {
                    ForEach($ingredients.indices, id: \.self) { index in
                        TextField("Ingrediente", text: $ingredients[index])
                    }
                    .onDelete(perform: deleteIngredient)
                    
                    Button(action: addIngredient) {
                        Label("Adicionar Ingrediente", systemImage: "plus")
                            .foregroundColor(.blue)
                    }
                }
                
                Section(header: Text("Modo de Preparo")) {
                    TextEditor(text: $preparationMethod)
                        .frame(minHeight: 120)
                }
            }
            .navigationTitle("Editar Receita")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvar") { saveRecipe() }
                    .fontWeight(.bold)
                }
            }
        }
    }
    
    private func addIngredient() {
        ingredients.append("")
    }
    
    private func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
    
    private func saveRecipe() {
        let updatedRecipe = Recipes(
            id: originalRecipe.id,
            rev: originalRecipe.rev,
            recipe_name: recipeName.isEmpty ? nil : recipeName,
            user_name: originalRecipe.user_name,
            recipe_image_url: imageUrl.isEmpty ? nil : imageUrl,
            recipe_description: recipeDescription.isEmpty ? nil : recipeDescription,
            ingredients: ingredients.filter { !$0.isEmpty },
            preparation_method: preparationMethod.isEmpty ? nil : preparationMethod,
            preparation_time: Int(preparationTime),
            category: originalRecipe.category,
            upvote: originalRecipe.upvote,
            downvote: originalRecipe.downvote,
            comments: originalRecipe.comments,
            save_counter: originalRecipe.save_counter
        )
        
        // AQUI: Chamamos o método put() da sua ViewModel
        viewModel.put(recipe: updatedRecipe)
        
        dismiss()
    }
}
