import SwiftUI

struct PokemonCardView: View {
    let summary: PokemonSummary

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
}

#Preview("여러 장") {
    VStack(spacing: 12) {
        PokemonCardView(summary: .bulbasaur)
        PokemonCardView(summary: .charmander)
        PokemonCardView(summary: .pikachu)
    }
    .padding()
    .frame(maxHeight: .infinity)
    .background(Color(.systemGroupedBackground))
}

#Preview("다크 모드") {
    PokemonCardView(summary: .pikachu)
        .padding()
        .background(Color(.systemGroupedBackground))
        .preferredColorScheme(.dark)
}
