import SwiftData
import SwiftUI

@main
struct PokedexApp: App {
    private let container: ModelContainer
    @State private var favorites: FavoritesStore
    
    init() {
        let container = try! ModelContainer(for: FavoritePokemon.self)
        self.container = container
        _favorites = State(initialValue: FavoritesStore(container: container))
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(favorites)
        }
        .modelContainer(container)
    }
}
