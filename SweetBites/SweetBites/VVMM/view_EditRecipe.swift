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
        // 1. Criamos uma cópia mutável da receita original (mantém _id, _rev, etc.)
        var updatedRecipe: Recipes = originalRecipe
        
        // 2. Atualizamos apenas os campos que podem ser editados no formulário
        updatedRecipe.recipe_name = recipeName.isEmpty ? nil : recipeName
        updatedRecipe.recipe_image_url = imageUrl.isEmpty ? nil : imageUrl
        updatedRecipe.recipe_description = recipeDescription.isEmpty ? nil : recipeDescription
        updatedRecipe.ingredients = ingredients.filter { !$0.isEmpty }
        updatedRecipe.preparation_method = preparationMethod.isEmpty ? nil : preparationMethod
        updatedRecipe.preparation_time = Int(preparationTime)
        
        // 3. Enviamos a receita atualizada para a ViewModel (que fará o PUT)
        viewModel.put(recipe: updatedRecipe)
        
        // 4. Fechamos a folha de edição
        dismiss()
    }
}
