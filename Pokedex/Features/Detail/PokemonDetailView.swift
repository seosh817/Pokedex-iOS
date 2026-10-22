import PokeAPI
import SwiftUI

struct PokemonDetailView: View {
    let summary: PokemonSummary
    @Environment(FavoritesStore.self) private var favorites
    @State private var viewModel = PokemonDetailViewModel()

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
                detailInfo
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .task {
            await viewModel.load(id: summary.id)
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
                            _ in favorites.toggle(summary)
                        }
                    )
                )
            }
        }
    }

    @ViewBuilder
    private var detailInfo: some View {
        if let detail = viewModel.detail {
            VStack(spacing: 20) {
                if let genus = detail.genus {
                    Text(genus)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                HStack(spacing: 40) {
                    stat("키", "\(detail.heightInMeters.formatted()) m")
                    stat("몸무게", "\(detail.weightInKilograms.formatted()) kg")
                }
                if let flavorText = detail.flavorText {
                    Text(flavorText)
                        .multilineTextAlignment(.center)
                }
                StatsCard(stats: detail.stats)
            }
            .padding(.top, 8)
        } else if let message = viewModel.errorMessage {
            Text(message)
                .foregroundStyle(.secondary)
        } else {
            ProgressView()
        }
    }

    private func stat(_ title: String, _ value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3.bold())
        }
    }
}

#Preview {
    NavigationStack {
        PokemonDetailView(summary: .pikachu)
    }
    .environment(FavoritesStore.preview(ids: [25]))
}
