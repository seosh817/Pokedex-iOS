import SwiftData
import SwiftUI

struct FavoritesListView: View {
    @Query(sort: \FavoritePokemon.addedAt, order: .reverse)
    private var favorites: [FavoritePokemon]
    
    var body: some View {
        PokemonListView(title: "즐겨찾기", summaries: favorites.map(\.summary))
            .overlay {
                if favorites.isEmpty {
                    ContentUnavailableView(
                        "즐겨찾기가 없어요",
                        systemImage: "star",
                        description: Text("도감에서 별을 눌러 추가해 보세요")
                    )
                }
            }
    }
}

#Preview {
    let store = FavoritesStore.preview(ids: [1, 25])
    NavigationStack {
        FavoritesListView()
    }
    .environment(store)
    .modelContainer(store.container)
}
