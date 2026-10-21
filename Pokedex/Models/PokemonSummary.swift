import Foundation

struct PokemonSummary: Identifiable, Hashable {
    let id: Int
    let name: String
    let koreanName: String
    let types: [String]

    var imageURL: URL? {
        URL(
            string:
                "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        )
    }
}
