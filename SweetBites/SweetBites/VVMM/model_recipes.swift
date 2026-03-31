//
//  model_recipes.swift
//  SweetBites
//
//  Created by Turma01-14 on 31/03/26.
//

import Foundation
import Combine

struct RecipesService {
}

struct Recipes: Codable, Identifiable {
    let id: String
    let rev: String?
    let recipe_name: String?
    let user_name: String?
    let recipe_image_url: String?
    let recipe_description: String?
    let ingredients: [String]?
    let preparation_method: String?
    let preparation_time: Int? // O tempo é em minutos.
    let category: [Int]? //Uma receita pode ser categorizada como refeição e um lanche, por exemplo
    let upvote: Int? // O que vai ser exibido é o delta de upvote e downvote.
    let downvote: Int?
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
