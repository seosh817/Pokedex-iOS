import SwiftUI

struct PokemonDetailView: View {
    let summary: PokemonSummary
    @Environment(FavoritesStore.self) private var favorites

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text(String(format: "#%03d", summary.id))
                    .font(.title.monospacedDigit().bold())
                    .foregroundStyle(.secondary)
                    .frame(width: 120, height: 120)
                    .background(.quaternary, in: .circle)
                Text(summary.koreanName)
                    .font(.largeTitle.bold())
                Text(summary.name.capitalized)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                HStack {
                    ForEach(summary.types, id: \.self) { type in
                        TypeBadge(type: type)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .navigationTitle(summary.koreanName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                FavoriteButton(
                    isOn: Binding(
                        get: {
                            favorites.contains(summary.id)
                        },
                        set: {
                            _ in favorites.toggle(summary.id)
                        }
                    )
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        PokemonDetailView(summary: .pikachu)
    }
    .environment(FavoritesStore(ids: [25]))
}
