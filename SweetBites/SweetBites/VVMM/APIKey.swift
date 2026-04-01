//
//  APIKey.swift
//  SweetBites
//
//  Created by Turma01-16 on 01/04/26.
//

import Foundation

enum APIKey{
    static var `default`: String {
        let value = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
        return value
    }
}
