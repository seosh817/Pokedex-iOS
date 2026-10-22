import Foundation
import Testing

@testable import PokeAPI

struct PokemonDetailTests {
    @Test("키와 몸무게를 m, kg 단위로 바꾼다", arguments: [
        (4, 60, 0.4, 6.0),
        (7, 69, 0.7, 6.9),
        (17, 905, 1.7, 90.5),
    ])
    func convertsUnits(height: Int, weight: Int, meters: Double, kilograms: Double) {
        let pokemon = Pokemon(id: 1, name: "test", height: height, weight: weight, types: [], stats: [])
        let species = PokemonSpecies(id: 1, names: [], genera: [], flavorTextEntries: [])
        let detail = PokemonDetail(pokemon: pokemon, species: species)
        #expect(detail.heightInMeters == meters)
        #expect(detail.weightInKilograms == kilograms)
    }

    @Test("능력치 이름을 한국어로 바꾼다", arguments: [
        ("hp", "HP"),
        ("attack", "공격"),
        ("defense", "방어"),
        ("special-attack", "특수공격"),
        ("special-defense", "특수방어"),
        ("speed", "스피드"),
        ("unknown", "unknown"),
    ])
    func koreanStatName(name: String, expected: String) {
        #expect(PokemonDetail.koreanStatName(name) == expected)
    }

    @Test("도감 설명의 줄바꿈을 띄어쓰기로 바꾼다", arguments: [
        ("서로의 꼬리를 붙여서\n전기를 흐르게 하는 게", "서로의 꼬리를 붙여서 전기를 흐르게 하는 게"),
        ("첫째 줄\u{0C}둘째 줄", "첫째 줄 둘째 줄"),
        ("줄바꿈 없음", "줄바꿈 없음"),
    ])
    func cleanFlavorText(text: String, expected: String) {
        #expect(PokemonDetail.cleanFlavorText(text) == expected)
    }

    @Test("한국어 분류와 가장 최근 한국어 도감 설명을 고른다")
    func picksKorean() {
        let ko = NamedResource(name: "ko", url: URL(string: "https://pokeapi.co/api/v2/language/3/")!)
        let en = NamedResource(name: "en", url: URL(string: "https://pokeapi.co/api/v2/language/9/")!)
        let species = PokemonSpecies(
            id: 25,
            names: [],
            genera: [.init(genus: "Mouse Pokémon", language: en), .init(genus: "쥐포켓몬", language: ko)],
            flavorTextEntries: [
                .init(flavorText: "옛날 설명", language: ko),
                .init(flavorText: "새 설명", language: ko),
                .init(flavorText: "English", language: en),
            ]
        )
        #expect(species.koreanGenus == "쥐포켓몬")
        #expect(species.koreanFlavorText == "새 설명")

        let noKorean = PokemonSpecies(id: 1000, names: [], genera: [], flavorTextEntries: [])
        #expect(noKorean.koreanFlavorText == nil)
    }
}
