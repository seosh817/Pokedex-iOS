import Foundation

nonisolated struct PokemonSpecies: Decodable {
    let id: Int
    let names: [LocalizedName]
    let genera: [Genus]
    let flavorTextEntries: [FlavorText]

    struct LocalizedName: Decodable {
        let name: String
        let language: NamedResource
    }

    struct Genus: Decodable {
        let genus: String
        let language: NamedResource
    }

    struct FlavorText: Decodable {
        let flavorText: String
        let language: NamedResource
    }

    var koreanName: String? {
        names.first { $0.language.name == "ko" }?.name
    }

    var koreanGenus: String? {
        genera.first { $0.language.name == "ko" }?.genus
    }

    var koreanFlavorText: String? {
        flavorTextEntries.last { $0.language.name == "ko" }?.flavorText
    }
}
