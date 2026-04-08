//
//  vm_recipes.swift
//  SweetBites
//
//  Created by Turma01-24 on 01/04/26.
//

import Foundation
import Combine

enum APIEndpointRecipes {
    case get, post, put, delete
    
    private var baseURL: String { "http://192.168.128.29:1880" }
    private var baseName: String { "SweetBitesRecipes" }
    
    var url: URL? {
        switch self {
            case .get:  return URL(string: "\(baseURL)/get\(baseName)")
            case .post: return URL(string: "\(baseURL)/post\(baseName)")
            case .put:  return URL(string: "\(baseURL)/put\(baseName)")
            case .delete: return URL(string: "\(baseURL)/delete\(baseName)")
        }
    }
}

class RecipesViewModel: ObservableObject {
    @Published var recipes: [Recipes] = []
    
    private let service = RecipesService()
    private var cancellables = Set<AnyCancellable>()
    
    func fetch() {
        guard let url = APIEndpointRecipes.get.url else { return }
        
        service.fetchRecipes(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] recipes in
                self?.recipes = recipes
            })
            .store(in: &cancellables)
    }
    
    func post(recipe: Recipes) {
        guard let url = APIEndpointRecipes.post.url else { return }
        
        service.addRecipe(recipe: recipe, url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.fetch()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func put(recipe: Recipes) {
        guard let url = APIEndpointRecipes.put.url else { return }
        
        service.updateRecipe(recipe: recipe, url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.fetch()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func delete(recipe: Recipes) {
        guard let url = APIEndpointRecipes.delete.url else { return }
        
        service.deleteRecipe(recipe: recipe, url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.fetch() 
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}
