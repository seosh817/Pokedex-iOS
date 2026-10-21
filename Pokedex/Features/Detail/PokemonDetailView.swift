import SwiftUI

struct PokemonDetailView: View {
    let summary: PokemonSummary
    @Environment(FavoritesStore.self) private var favorites

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                PokemonImage(url: summary.imageURL)
                    .frame(width: 240, height: 240)
                    .background(.quaternary, in: .circle)
                    .overlay(alignment: .bottom) {
                        Text(String(format: "#%03d", summary.id))
                            .font(.title3.monospacedDigit().bold())
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .glassCapsule()
                    }
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
