import Testing

@testable import Pokedex

@MainActor
struct PokemonNameIndexTests {
    @Test("앱에 들어 있는 이름 목록을 읽는다")
    func bundled() {
        #expect(PokemonNameIndex.bundled.names.count == 1025)
    }

    @Test("한국어 일부, 영어 대소문자, 번호로 찾는다", arguments: [
        ("이상해", [1, 2, 3]),
        ("피카츄", [25]),
        ("MEW", [150, 151]),
        ("150", [150]),
        ("#25", [25]),
        ("없는 이름", []),
    ])
    func matching(query: String, expected: [Int]) {
        #expect(PokemonNameIndex.bundled.ids(matching: query) == expected)
    }
}
