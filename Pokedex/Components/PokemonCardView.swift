import SwiftUI
import PokeAPI

struct PokemonCardView: View {
    let summary: PokemonSummary
    let isFavorite: Bool
    @Environment(FavoritesStore.self) private var favorites

    var body: some View {
        HStack(spacing: 16) {
            PokemonImage(url: summary.imageURL)
                .frame(width: 64, height: 64)
                .background(.quaternary, in: .circle)

            VStack(alignment: .leading, spacing: 6) {
                Text(String(format: "#%03d", summary.id))
                    .font(.caption.monospacedDigit().bold())
                    .foregroundStyle(.secondary)
                Text(summary.koreanName)
                    .font(.headline)
                Text(summary.name.capitalized)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack(spacing: 6) {
                    ForEach(summary.types, id: \.self) { type in
                        TypeBadge(type: type)
                    }
                }
            }

            Spacer()

            FavoriteButton(
                isOn: Binding(
                    get: { isFavorite },
                    set: { _ in favorites.toggle(summary) }
                )
            )
        }
        .cardStyle()
    }
}

#Preview("피카츄") {
    PokemonCardView(summary: .pikachu, isFavorite: true)
        .padding()
        .environment(FavoritesStore.preview(ids: [25]))
}

#Preview("여러 장") {
    CardListPreview()
        .environment(FavoritesStore.preview(ids: [25]))
}

#Preview("다크 모드") {
    PokemonCardView(summary: .pikachu, isFavorite: false)
        .padding()
        .background(Color(.systemGroupedBackground))
        .preferredColorScheme(.dark)
        .environment(FavoritesStore.preview())
}

private struct CardListPreview: View {
    @Environment(FavoritesStore.self) private var favorites
    let summaries: [PokemonSummary] = [.bulbasaur, .charmander, .pikachu]

    var body: some View {
        @Bindable var favorites = favorites
        VStack(spacing: 12) {
            Toggle("즐겨찾기만 보기", isOn: $favorites.showOnlyFavorites)
            Text("즐겨찾기 \(favorites.ids.count)마리")
                .font(.headline)
            ForEach(visibleSummaries) { summary in
                PokemonCardView(summary: summary, isFavorite: favorites.contains(summary.id))
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }

    private var visibleSummaries: [PokemonSummary] {
        if favorites.showOnlyFavorites {
            summaries.filter { favorites.contains($0.id) }
        } else {
            summaries
        }
    }
}
