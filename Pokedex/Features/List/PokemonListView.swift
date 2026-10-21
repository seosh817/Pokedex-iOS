import SwiftUI

struct PokemonListView: View {
    let title: String
    let summaries: [PokemonSummary]
    var isLoadingMore = false
    var onReachEnd: (() async -> Void)? = nil
    @Environment(FavoritesStore.self) private var favorites

    var body: some View {
        List {
            ForEach(summaries) { summary in
                NavigationLink(value: summary) {
                    PokemonCardView(summary: summary, isFavorite: favorites.contains(summary.id))
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .task {
                    if summary.id == summaries.last?.id {
                        await onReachEnd?()
                    }
                }
            }

            if isLoadingMore {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle(title)
        .navigationDestination(for: PokemonSummary.self) { summary in
            PokemonDetailView(summary: summary)
        }
    }
}

#Preview {
    NavigationStack {
        PokemonListView(title: "도감", summaries: PokemonSummary.samples)
    }
    .environment(FavoritesStore(ids: [25]))
}
