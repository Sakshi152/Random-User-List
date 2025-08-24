//
//  User.swift
//  RandomUserList


import Foundation

struct User: Codable, Identifiable, Equatable {
    let id = UUID() // Unique identifier for each user
    let name: Name
    let email: String
    let picture: Picture
    let location: Location?
    
    // Name sub-struct
    struct Name: Codable, Equatable {
        let title: String
        let first: String
        let last: String
        
        var fullName: String {
            return "\(title). \(first) \(last)"
        }
    }
    
    // Picture sub-struct
    struct Picture: Codable, Equatable {
        let large: String
        let medium: String
        let thumbnail: String
    }
    
    // Location sub-struct
    struct Location: Codable, Equatable {
        let city: String
        let country: String
    }
    
    // Implement Equatable conformance
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id // Compare users based on their unique `id`
    }
}

struct UserResponse: Codable {
    let results: [User]
}
