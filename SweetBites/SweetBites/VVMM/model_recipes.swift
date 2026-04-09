//
//  model_recipes.swift
//  SweetBites
//
//  Created by Turma01-14 on 31/03/26.
//

import Foundation
import Combine

struct RecipesService {
    
    
    func fetchRecipes(url: URL) -> AnyPublisher<[Recipes], Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Recipes].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func addRecipe(recipe: Recipes, url: URL) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(recipe)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    func updateRecipe(recipe: Recipes, url: URL) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(recipe)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func deleteRecipe(recipe: Recipes, url: URL) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(recipe)
            request.httpBody = jsonData

        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

struct Recipes: Codable, Identifiable {
    let id: String
    let rev: String?
    
    // Transforme os campos que podem ser editados no app em 'var'
    var recipe_name: String?
    var user_name: String?
    var recipe_image_url: String?
    var recipe_description: String?
    var ingredients: [String]?
    var preparation_method: String?
    var preparation_time: Int?
    
    // Os demais podem continuar como 'let' se não mudarem na edição,
    // ou 'var' como já estão.
    let category: [Int]?
    var upvote: [String]?
    var downvote: [String]?
    let comments: [Comments]?
    let save_counter: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case rev = "_rev"
        case recipe_name, user_name, recipe_image_url, recipe_description, ingredients, preparation_method, preparation_time, category, upvote, downvote, comments, save_counter
    }
}

struct Comments: Codable, Hashable {
    let user_id: String?
    let comment: String?
    
    enum CodingKeys: String, CodingKey {
        case user_id = "_id"
        case comment
    }
}
