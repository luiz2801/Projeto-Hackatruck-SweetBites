//
//  vm_user.swift
//  SweetBites
//
//  Created by Turma01-24 on 01/04/26.
//

import Foundation
import Combine

enum APIEndpointRecipes {
    case get, post, put, delete
    
    private var baseURL: String { "http://127.0.0.1:1880" }
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
