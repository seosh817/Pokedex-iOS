import Observation

@Observable
final class FavoritesStore {
    private(set) var ids: Set<Int>
    var showOnlyFavorites = false
    
    init(ids: Set<Int> = []) {
        self.ids = ids
    }
    
    func contains(_ id: Int) -> Bool {
        ids.contains(id)
    }
    
    func toggle(_ id: Int) {
        if ids.contains(id) {
            ids.remove(id)
        } else {
            ids.insert(id)
        }
    }
}
