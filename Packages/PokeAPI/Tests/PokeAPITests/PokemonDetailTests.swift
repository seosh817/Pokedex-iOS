import Testing

@testable import PokeAPI

struct PokemonDetailTests {
    @Test("키와 몸무게를 m, kg 단위로 바꾼다", arguments: [
        (4, 60, 0.4, 6.0),
        (7, 69, 0.7, 6.9),
        (17, 905, 1.7, 90.5),
    ])
    func convertsUnits(height: Int, weight: Int, meters: Double, kilograms: Double) {
        let pokemon = Pokemon(id: 1, name: "test", height: height, weight: weight, types: [])
        let detail = PokemonDetail(pokemon)
        #expect(detail.heightInMeters == meters)
        #expect(detail.weightInKilograms == kilograms)
    }
}
