import SwiftData
import Testing

@testable import Pokedex

@MainActor
struct FavoritesStoreTests {
    let container: ModelContainer
    
    init() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: FavoritePokemon.self, configurations: configuration)
    }
    
    @Test("토글하면 즐겨찾기에 들어갔다가 빠진다")
    func toggle() async throws {
        let store = FavoritesStore(container: container)
        store.toggle(.pikachu)
        #expect(store.contains(25))
        #expect(try container.mainContext.fetchCount(FetchDescriptor<FavoritePokemon>()) == 1)
        
        store.toggle(.pikachu)
        #expect(!store.contains(25))
        #expect(try container.mainContext.fetchCount(FetchDescriptor<FavoritePokemon>()) == 0)
    }
    
    @Test("저장소를 새로 만들어도 저장된 즐겨찾기를 불러온다")
    func reload() {
        let first = FavoritesStore(container: container)
        first.toggle(.bulbasaur)
        first.toggle(.pikachu)
        
        let second = FavoritesStore(container: container)
        #expect(second.ids == [1, 25])
    }
}
