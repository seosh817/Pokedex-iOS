import Foundation
import Observation
import SwiftData

@Observable
final class FavoritesStore {
    private(set) var ids: Set<Int> = []
    var showOnlyFavorites = false
    
    let container: ModelContainer
    private var context: ModelContext { container.mainContext }
    
    init(container: ModelContainer) {
        self.container = container
        let saved = (try? context.fetch(FetchDescriptor<FavoritePokemon>())) ?? []
        ids = Set(saved.map(\.id))
    }
    
    func contains(_ id: Int) -> Bool {
        ids.contains(id)
    }
    
    func toggle(_ summary: PokemonSummary) {
        if let saved = favorite(id: summary.id) {
            context.delete(saved)
            ids.remove(summary.id)
        } else {
            context.insert(FavoritePokemon(summary: summary))
            ids.insert(summary.id)
        }
        try? context.save()
    }
    
    private func favorite(id: Int) -> FavoritePokemon? {
        var descriptor = FetchDescriptor<FavoritePokemon>(predicate: #Predicate { $0.id == id})
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }
}
