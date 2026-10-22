import SwiftUI

struct PokedexView: View {
    @Environment(FavoritesStore.self) private var favorites
    @State private var viewModel = PokedexViewModel()
    @State private var showsFilter = false

    var body: some View {
        PokemonListView(
            title: "도감",
            summaries: visibleSummaries,
            isLoadingMore: viewModel.isLoading,
            onReachEnd: { await viewModel.loadNextPage() }
        )
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
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.loadFirstPageIfNeeded()
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
        viewModel.summaries.filter { favorites.contains($0.id) }
    }

    private var visibleSummaries: [PokemonSummary] {
        favorites.showOnlyFavorites ? favoriteSummaries : viewModel.summaries
    }
}

#Preview {
    NavigationStack {
        PokedexView()
    }
    .environment(FavoritesStore.preview(ids: [1, 25]))
}
