import Foundation
import SwiftData
import PokeAPI

@Model
final class FavoritePokemon {
    @Attribute(.unique) var id: Int
    var name: String
    var koreanName: String
    var types: [String]
    var addedAt: Date
    
    init(summary: PokemonSummary, addedAt: Date = .now) {
        self.id = summary.id
        self.name = summary.name
        self.koreanName = summary.koreanName
        self.types = summary.types
        self.addedAt = addedAt
    }
    
    var summary: PokemonSummary {
        PokemonSummary(id: id, name: name, koreanName: koreanName, types: types)
    }
}
