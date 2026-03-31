//
//  model_user.swift
//  SweetBites
//
//  Created by Turma01-14 on 31/03/26.
//

import Foundation
import Combine

struct UserService {
}

struct User: Codable, Identifiable {
    let id: String
    let rev: String?
    let user_name: String?
    let user_image_url: String?
    let user_description: String?
    let user_recipes: [String]?
    let rt_recipes: [String]?
    let save_recipes: [String]?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case rev = "_rev"
        case user_name, user_image_url, user_description, user_recipes, rt_recipes, save_recipes
    }
}
