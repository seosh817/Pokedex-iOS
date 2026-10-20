import Foundation

struct PokemonSummary: Identifiable, Hashable {
    let id: Int
    let name: String
    let koreanName: String
    let types: [String]
}
