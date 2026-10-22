import Foundation

public struct PokemonSummary: Identifiable, Hashable, Sendable {
    public let id: Int
    public let name: String
    public let koreanName: String
    public let types: [String]

    public init(id: Int, name: String, koreanName: String, types: [String]) {
        self.id = id
        self.name = name
        self.koreanName = koreanName
        self.types = types
    }

    public var imageURL: URL? {
        URL(
            string:
                "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        )
    }
}
