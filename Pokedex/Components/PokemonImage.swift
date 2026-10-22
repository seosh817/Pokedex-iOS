import NukeUI
import PokeAPI
import SwiftUI

struct PokemonImage: View {
    let url: URL?

    var body: some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if state.error != nil {
                Image(systemName: "questionmark")
                    .font(.title)
                    .foregroundStyle(.secondary)
            } else {
                ProgressView()
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    HStack {
        PokemonImage(url: PokemonSummary.pikachu.imageURL)
        PokemonImage(url: URL(string: "https://example.com/없는-그림.png"))
    }
    .frame(height: 120)
    .padding()
}
