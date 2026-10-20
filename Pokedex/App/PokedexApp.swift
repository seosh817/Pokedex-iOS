import SwiftUI

@main
struct PokedexApp: App {
    @State private var favorites = FavoritesStore()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(favorites)
        }
    }
}
