//
//  vm_user.swift
//  SweetBites
//
//  Created by Turma01-24 on 01/04/26.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    
    private let service = UserService()
    private var cancellables = Set<AnyCancellable>()
    
    func fetch() {
        guard let url = APIEndpointUser.get.url else { return }
        
        service.fetchUsers(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] users in
                self?.users = users
            })
            .store(in: &cancellables)
    }
    
    func post(user: User) {
        guard let url = APIEndpointUser.post.url else { return }
        
        service.addUser(user: user, url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.fetch()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func put(user: User) {
        guard let url = APIEndpointUser.put.url else { return }
        
        service.updateUser(user: user, url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.fetch()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func delete(user: User) {
        guard let url = APIEndpointUser.delete.url else { return }
        
        service.deleteUser(user: user, url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.fetch()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}

enum APIEndpointUser {
    case get, post, put, delete
    
    private var baseURL: String { "http://127.0.0.1:1880" }
    private var baseName: String { "SweetBitesUser" }
    
    var url: URL? {
        switch self {
            case .get:  return URL(string: "\(baseURL)/get\(baseName)")
            case .post: return URL(string: "\(baseURL)/post\(baseName)")
            case .put:  return URL(string: "\(baseURL)/put\(baseName)")
            case .delete: return URL(string: "\(baseURL)/delete\(baseName)")
        }
    }
}
