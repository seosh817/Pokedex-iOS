public struct PokemonDetail: Equatable, Sendable {
    public let id: Int
    public let heightInMeters: Double
    public let weightInKilograms: Double
    public let genus: String?
    public let flavorText: String?
    public let stats: [Stat]

    public struct Stat: Equatable, Sendable, Identifiable {
        public let name: String
        public let value: Int

        public var id: String { name }

        public init(name: String, value: Int) {
            self.name = name
            self.value = value
        }
    }

    public init(
        id: Int,
        heightInMeters: Double,
        weightInKilograms: Double,
        genus: String? = nil,
        flavorText: String? = nil,
        stats: [Stat] = []
    ) {
        self.id = id
        self.heightInMeters = heightInMeters
        self.weightInKilograms = weightInKilograms
        self.genus = genus
        self.flavorText = flavorText
        self.stats = stats
    }
}

extension PokemonDetail {
    init(pokemon: Pokemon, species: PokemonSpecies) {
        self.init(
            id: pokemon.id,
            heightInMeters: Double(pokemon.height) / 10,
            weightInKilograms: Double(pokemon.weight) / 10,
            genus: species.koreanGenus,
            flavorText: species.koreanFlavorText.map(Self.cleanFlavorText),
            stats: pokemon.stats.map {
                Stat(name: Self.koreanStatName($0.stat.name), value: $0.baseStat)
            }
        )
    }

    static func koreanStatName(_ name: String) -> String {
        switch name {
        case "hp": "HP"
        case "attack": "공격"
        case "defense": "방어"
        case "special-attack": "특수공격"
        case "special-defense": "특수방어"
        case "speed": "스피드"
        default: name
        }
    }

    static func cleanFlavorText(_ text: String) -> String {
        text.replacing("\n", with: " ").replacing("\u{0C}", with: " ")
    }
}
