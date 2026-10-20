import SwiftUI

struct PokemonListView: View {
    let title: String
    let summaries: [PokemonSummary]
    
    var body: some View {
        List(summaries) { summary in
            NavigationLink(value: summary) {
                PokemonCardView(summary: summary)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
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
