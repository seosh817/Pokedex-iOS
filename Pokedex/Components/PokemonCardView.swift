import SwiftUI

struct PokemonCardView: View {
    let summary: PokemonSummary
    @Environment(FavoritesStore.self) private var favorites

    var body: some View {
        HStack(spacing: 16) {
            Text(String(format: "#%03d", summary.id))
                .font(.subheadline.monospacedDigit().bold())
                .foregroundStyle(.secondary)
                .frame(width: 56, height: 56)
                .background(.quaternary, in: .circle)

            VStack(alignment: .leading, spacing: 6) {
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
                    get: { favorites.contains(summary.id) },
                    set: { _ in favorites.toggle(summary.id)}
                )
            )
        }
        .padding()
        .background(
            Color(.secondarySystemGroupedBackground)
                .shadow(.drop(color: .black.opacity(0.1), radius: 4, y: 2)),
            in: .rect(cornerRadius: 16)
        )
    }
}

#Preview("피카츄") {
    PokemonCardView(summary: .pikachu)
        .padding()
        .environment(FavoritesStore(ids: [25]))
}

#Preview("여러 장") {
    CardListPreview()
        .environment(FavoritesStore(ids: [25]))
}

#Preview("다크 모드") {
    PokemonCardView(summary: .pikachu)
        .padding()
        .background(Color(.systemGroupedBackground))
        .preferredColorScheme(.dark)
        .environment(FavoritesStore())
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
                PokemonCardView(summary: summary)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }

    private var visibleSummaries: [PokemonSummary] {
        if favorites.showOnlyFavorites {
            summaries.filter { favorites.contains($0.id)}
        } else {
            summaries
        }
    }
}
