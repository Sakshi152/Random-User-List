//
//  FavoritesView.swift
//  RandomUserList
//


import SwiftUI

struct FavoritesView: View {
    @Binding var favoriteUsers: [User]
    @State private var userToDelete: User? = nil
    @State private var showDeleteAlert = false
    
    var body: some View {
        List {
            ForEach(favoriteUsers) { user in
                HStack {
                    AsyncImage(url: URL(string: user.picture.medium)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    
                    Text(user.name.fullName)
                        .font(.headline)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        userToDelete = user
                        showDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .navigationTitle("Favorites")
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete User"),
                message: Text("Are you sure you want to delete this user from favorites?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let user = userToDelete {
                        deleteUser(user)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func deleteUser(_ user: User) {
        favoriteUsers.removeAll { $0 == user }
    }
}
