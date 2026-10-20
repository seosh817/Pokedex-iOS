import SwiftUI

struct PokemonCardView: View {
    let summary: PokemonSummary
    @Binding var isFavorite: Bool

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

            FavoriteButton(isOn: $isFavorite)
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
    PokemonCardView(summary: .pikachu, isFavorite: .constant(true))
        .padding()
}

#Preview("여러 장") {
    CardListPreview()
}

#Preview("다크 모드") {
    PokemonCardView(summary: .pikachu, isFavorite: .constant(true))
        .padding()
        .background(Color(.systemGroupedBackground))
        .preferredColorScheme(.dark)
}

private struct CardListPreview: View {
    @State private var favorites: Set<Int> = [25]
    let summaries: [PokemonSummary] = [.bulbasaur, .charmander, .pikachu]

    var body: some View {
        VStack(spacing: 12) {
            Text("즐겨찾기 \(favorites.count)마리")
                .font(.headline)
            ForEach(summaries) { summary in
                PokemonCardView(summary: summary, isFavorite: isFavorite(summary.id))
            }
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
 
    private func isFavorite(_ id: Int) -> Binding<Bool> {
        Binding(
            get: { favorites.contains(id)},
            set: { isOn in
                if isOn {
                    favorites.insert(id)
                } else {
                    favorites.remove(id)
                }
            }
        )
    }
}
