//
//  model_user.swift
//  SweetBites
//
//  Created by Turma01-14 on 31/03/26.
//

import Foundation
import Combine

struct UserService {
    func fetchUsers(url: URL) -> AnyPublisher<[User], Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [User].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func addUser(user: User, url: URL) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    func updateUser(user: User, url: URL) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func deleteUser(user: User, url: URL) -> AnyPublisher<Data, Error> {
            var request = URLRequest(url: url)
            
            request.httpMethod = "DELETE"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = try JSONEncoder().encode(user)
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .map(\.data)
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
        }
}

struct User: Codable, Identifiable {
    let id: String
    let rev: String?
    var user_name: String?
    var user_image_url: String?
    var user_description: String?
    let user_recipes: [String]?
    var rt_recipes: [String]?
    var save_recipes: [String]?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case rev = "_rev"
        case user_name, user_image_url, user_description, user_recipes, rt_recipes, save_recipes
    }
}
