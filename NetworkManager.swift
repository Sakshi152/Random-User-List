//
//  NetworkManager.swift
//  RandomUserList
//
//


import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchUsers(page: Int = 1) -> AnyPublisher<[User], Error> {
        let url = URL(string: "https://randomuser.me/api/?results=10&page=\(page)")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .map { $0.results }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
