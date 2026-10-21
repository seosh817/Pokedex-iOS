import SwiftUI

struct MainTabView: View {
    @Environment(FavoritesStore.self) private var favorites
    @State private var pokedex = PokedexViewModel()
    @State private var showsFilter = false

    var body: some View {
        TabView {
            NavigationStack {
                PokemonListView(
                    title: "도감",
                    summaries: visibleSummaries,
                    isLoadingMore: pokedex.isLoading,
                    onReachEnd: { await pokedex.loadNextPage() }
                )
                .overlay {
                    if pokedex.summaries.isEmpty {
                        if let message = pokedex.errorMessage {
                            ContentUnavailableView {
                                Label("불러오지 못했어요", systemImage: "wifi.exclamationmark")
                            } description: {
                                Text(message)
                            } actions: {
                                Button("다시 시도") {
                                    Task { await pokedex.refresh() }
                                }
                            }
                        } else {
                            ProgressView("불러오는 중")
                        }
                    }
                }
                .refreshable {
                    await pokedex.refresh()
                }
                .task {
                    await pokedex.loadFirstPageIfNeeded()
                }
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
        pokedex.summaries.filter { favorites.contains($0.id) }
    }

    private var visibleSummaries: [PokemonSummary] {
        favorites.showOnlyFavorites ? favoriteSummaries : pokedex.summaries
    }
}

#Preview {
    MainTabView()
        .environment(FavoritesStore(ids: [1, 25]))
}
