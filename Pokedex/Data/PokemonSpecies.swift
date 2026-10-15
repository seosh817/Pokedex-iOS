import Foundation

struct PokemonSpecies: Decodable {
    let id: Int
    let names: [LocalizedName]

    struct LocalizedName: Decodable {
        let name: String
        let language: NamedResource
    }

    var koreanName: String? {
        names.first { $0.language.name == "ko" }?.name
    }
}
