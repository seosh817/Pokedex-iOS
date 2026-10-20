import SwiftUI

struct MainTabView: View {
    @Environment(FavoritesStore.self) private var favorites
    @State private var showsFilter = false
    
    private let allSummaries = PokemonSummary.samples
    
    var body: some View {
        TabView {
            NavigationStack {
                PokemonListView(title: "도감", summaries: visibleSummaries)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                showsFilter = true
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                            }
                            .accessibilityLabel("보기 설정")
                        }
                    }
            }
            .tabItem {
                Label("도감", systemImage: "list.bullet")
            }
            
            NavigationStack {
                PokemonListView(title: "즐겨찾기", summaries: favoriteSummaries)
            }
            .tabItem {
                Label("즐겨찾기", systemImage: "star.fill")
            }
            .badge(favorites.ids.count)
        }
        .sheet(isPresented: $showsFilter) {
            FilterSheet()
                .presentationDetents([.medium])
        }
    }
    
    private var favoriteSummaries: [PokemonSummary] {
        allSummaries.filter { favorites.contains($0.id)}
    }
    
    private var visibleSummaries: [PokemonSummary] {
        favorites.showOnlyFavorites ? favoriteSummaries : allSummaries
    }
}

#Preview {
    MainTabView()
        .environment(FavoritesStore(ids: [1, 25]))
}
