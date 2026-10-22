import SwiftUI
import PokeAPI

struct PokemonImage: View {
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure:
                Image(systemName: "questionmark")
                    .font(.title)
                    .foregroundStyle(.secondary)
            default:
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
