import SwiftData
import SwiftUI

struct MainTabView: View {
    @Environment(FavoritesStore.self) private var favorites

    var body: some View {
        TabView {
            NavigationStack {
                PokedexView()
            }
            .tabItem {
                Label("도감", systemImage: "list.bullet")
            }

            NavigationStack {
                FavoritesListView()
            }
            .tabItem {
                Label("즐겨찾기", systemImage: "star.fill")
            }
            .badge(favorites.ids.count)
        }
    }
}

#Preview {
    let store = FavoritesStore.preview(ids: [1, 25])
    MainTabView()
        .environment(store)
        .modelContainer(store.container)
}
