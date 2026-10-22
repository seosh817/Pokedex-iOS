import SwiftData
import PokeAPI

extension FavoritesStore {
    static func preview(ids: Set<Int> = []) -> FavoritesStore {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: FavoritePokemon.self, configurations: configuration)
        let store = FavoritesStore(container: container)
        for summary in PokemonSummary.samples where ids.contains(summary.id) {
            store.toggle(summary)
        }
        return store
    }
}
