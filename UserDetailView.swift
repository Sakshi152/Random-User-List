import SwiftUI

struct UserDetailView: View {
    let user: User
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            userProfileImage
            userName
            userDetails
            favoriteButton
            Spacer()
        }
        .padding()
        .navigationTitle("User Details")
    }
    
    // MARK: - Subviews
    
    // User Profile Image
    private var userProfileImage: some View {
        AsyncImage(url: URL(string: user.picture.large)) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 150, height: 150)
        .clipShape(Circle())
    }
    
    // User Name
    private var userName: some View {
        Text(user.name.fullName)
            .font(.title)
            .bold()
    }
    
    // User Details (Email and Location)
    private var userDetails: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Email: \(user.email)")
                .font(.body)
            
            if let location = user.location {
                Text("Location: \(location.city), \(location.country)")
                    .font(.body)
            }
        }
        .padding()
    }
    
    // Favorite Button
    private var favoriteButton: some View {
        Button(action: {
            viewModel.toggleFavorite(user: user)
        }) {
            HStack {
                Image(systemName: viewModel.favoriteUsers.contains(where: { $0 == user }) ? "heart.fill" : "heart")
                    .foregroundColor(.red)
                Text(viewModel.favoriteUsers.contains(where: { $0 == user }) ? "Remove from Favorites" : "Add to Favorites")
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}
