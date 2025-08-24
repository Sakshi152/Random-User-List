//
//  UserViewModel.swift
//  RandomUserList
//
//  Created by Sakshi on 28/02/25.
//


import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var searchText: String = ""
    @Published var currentPage = 1
    @Published var favoriteUsers: [User] = []
    private var cancellables = Set<AnyCancellable>()
    
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { $0.name.fullName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    init() {
        fetchUsers()
        loadFavorites()
    }
    
    func fetchUsers() {
        NetworkManager.shared.fetchUsers(page: currentPage)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] newUsers in
                self?.users.append(contentsOf: newUsers)
                self?.currentPage += 1
            })
            .store(in: &cancellables)
    }
    
    func toggleFavorite(user: User) {
        if let index = favoriteUsers.firstIndex(where: { $0.id == user.id }) {
            favoriteUsers.remove(at: index)
        } else {
            favoriteUsers.append(user)
        }
        saveFavorites()
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteUsers) {
            UserDefaults.standard.set(encoded, forKey: "favoriteUsers")
        }
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favoriteUsers"),
           let decoded = try? JSONDecoder().decode([User].self, from: data) {
            favoriteUsers = decoded
        }
    }
}