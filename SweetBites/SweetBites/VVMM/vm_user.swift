//
//  vm_user.swift//  SweetBites
//
//  Created by Turma01-24 on 01/04/26.
//

import Foundation
import Combine

enum APIEndpointUsers {
    case get, post, put, delete
    
    // Mantendo o mesmo IP e porta do seu arquivo de receitas
    private var baseURL: String { "http://192.168.128.15:1880" }
    private var baseName: String { "SweetBitesUsers" } // Ajuste se o endpoint no Node-RED for diferente
    
    var url: URL? {
        switch self {
            case .get:  return URL(string: "\(baseURL)/get\(baseName)")
            case .post: return URL(string: "\(baseURL)/post\(baseName)")
            case .put:  return URL(string: "\(baseURL)/put\(baseName)")
            case .delete: return URL(string: "\(baseURL)/delete\(baseName)")
        }
    }
}

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    
    private let service = UserService()
    private var cancellables = Set<AnyCancellable>()
    
    func fetch() {
        guard let url = APIEndpointUsers.get.url else { return }
        
        service.fetchUsers(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] users in
                self?.users = users
            })
            .store(in: &cancellables)
    }
    
    func post(user: User) {
        guard let url = APIEndpointUsers.post.url else { return }
        
        service.addUser(user: user, url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.fetch()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func put(user: User) {
        guard let url = APIEndpointUsers.put.url else { return }
        
        service.updateUser(user: user, url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.fetch()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func delete(user: User) {
        guard let url = APIEndpointUsers.delete.url else { return }
        
        service.deleteUser(user: user, url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.fetch()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}
