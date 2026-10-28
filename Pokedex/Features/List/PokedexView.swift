import SwiftUI
import PokeAPI

struct PokedexView: View {
    @Environment(FavoritesStore.self) private var favorites
    @State private var viewModel = PokedexViewModel()
    @State private var showsFilter = false

    var body: some View {
        PokemonListView(
            title: "도감",
            summaries: visibleSummaries,
            isLoadingMore: viewModel.isLoading || viewModel.isFetchingSearchResults,
            onReachEnd: {
                if viewModel.isSearching {
                    await viewModel.loadMoreSearchResults()
                } else {
                    await viewModel.loadNextPage()
                }
            }
        )
        .searchable(text: $viewModel.searchText, prompt: "이름 또는 번호")
        .overlay {
            if viewModel.summaries.isEmpty {
                if let message = viewModel.errorMessage {
                    ContentUnavailableView {
                        Label(
                            "불러오지 못했어요",
                            systemImage: "wifi.exclamationmark"
                        )
                    } description: {
                        Text(message)
                    } actions: {
                        Button("다시 시도") {
                            Task { await viewModel.refresh() }
                        }
                    }
                } else {
                    ProgressView("불러오는 중")
                }
            } else if viewModel.isSearching && visibleSummaries.isEmpty {
                if viewModel.isFetchingSearchResults {
                    ProgressView("찾는 중")
                } else {
                    ContentUnavailableView(
                        "검색 결과가 없어요",
                        systemImage: "magnifyingglass",
                        description: Text("이름이나 번호를 다시 확인해 주세요.")
                    )
                }
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.loadFirstPageIfNeeded()
        }
        .task(id: viewModel.searchText) {
            await viewModel.search()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showsFilter = true
                } label: {
                    Image(
                        systemName: "line.3.horizontal.decrease.circle"
                    )
                }
                .accessibilityLabel("보기 설정")
            }
        }
        .sheet(isPresented: $showsFilter) {
            FilterSheet()
                .presentationDetents([.medium])
        }
    }

    private var favoriteSummaries: [PokemonSummary] {
        viewModel.searchResults.filter { favorites.contains($0.id) }
    }

    private var visibleSummaries: [PokemonSummary] {
        favorites.showOnlyFavorites ? favoriteSummaries : viewModel.searchResults
    }
}

#Preview {
    NavigationStack {
        PokedexView()
    }
    .environment(FavoritesStore.preview(ids: [1, 25]))
}
