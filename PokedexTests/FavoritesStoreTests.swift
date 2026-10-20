import Testing

@testable import Pokedex

@MainActor
struct FavoritesStoreTests {
    @Test("토글하면 즐겨찾기에 들어갔다가 빠진다")
    func toggle() async throws {
        let store = FavoritesStore()
        store.toggle(25)
        #expect(store.contains(25))
        store.toggle(25)
        #expect(!store.contains(25))
    }
    
    @Test("처음 넣는 id는 즐겨찾기다")
    func initialIDs() {
        let store = FavoritesStore(ids: [1, 25])
        #expect(store.ids == [1, 25])
        #expect(store.contains(1))
        #expect(!store.contains(4))
    }
}
