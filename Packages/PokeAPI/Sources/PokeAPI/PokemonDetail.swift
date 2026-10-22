public struct PokemonDetail: Equatable, Sendable {
    public let id: Int
    public let heightInMeters: Double
    public let weightInKilograms: Double

    public init(id: Int, heightInMeters: Double, weightInKilograms: Double) {
        self.id = id
        self.heightInMeters = heightInMeters
        self.weightInKilograms = weightInKilograms
    }
}

extension PokemonDetail {
    init(_ pokemon: Pokemon) {
        self.init(
            id: pokemon.id,
            heightInMeters: Double(pokemon.height) / 10,
            weightInKilograms: Double(pokemon.weight) / 10
        )
    }
}
