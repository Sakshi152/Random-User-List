//
//  ContentView.swift
//  RandomUserList

//


import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                
                List {
                    ForEach(viewModel.filteredUsers) { user in
                        NavigationLink(destination: UserDetailView(user: user, viewModel: viewModel)) {
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
                        }
                        .onAppear {
                            if user == viewModel.filteredUsers.last {
                                viewModel.fetchUsers()
                            }
                        }
                    }
                }
                .refreshable {
                    viewModel.fetchUsers()
                }
                .navigationTitle("Random Users")
                
                NavigationLink(destination: FavoritesView(favoriteUsers: $viewModel.favoriteUsers)) {
                    Text("View Favorites")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal)
    }
}
