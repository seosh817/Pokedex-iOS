import Testing

@testable import PokeAPI

@MainActor
struct PokeAPIClientTests {
    let client = PokeAPIClient()

    @Test("피카츄 상세 정보를 불러온다")
    func fetchPikachu() async throws {
        let pikachu = try await client.fetchPokemon(id: 25)
        #expect(pikachu.name == "pikachu")
        #expect(pikachu.types.map(\.type.name) == ["electric"])
    }

    @Test("상세 화면 정보를 두 요청으로 한 번에 불러온다")
    func fetchDetail() async throws {
        let detail = try await client.fetchDetail(id: 25)
        #expect(detail.genus == "쥐포켓몬")
        #expect(
            detail.stats.map(\.name) == [
                "HP", "공격", "방어", "특수공격", "특수방어", "스피드",
            ]
        )
        #expect(detail.stats.first?.value == 35)
        let flavorText = try #require(detail.flavorText)
        #expect(!flavorText.contains("\n"))
    }

    @Test("시작 전에 취소하면 에러가 난다")
    func cancelBeforeStarting() async {
        let task = Task { try await client.fetchPokemon(id: 25) }
        task.cancel()
        do {
            _ = try await task.value
            Issue.record("에러가 나야 하는데 성공했다")
        } catch {
            print("취소 에러:", type(of: error), error)
        }
    }

    @Test("Task.sleep은 취소되면 CancellationError를 던진다")
    func sleepCancel() async {
        let task = Task { try await Task.sleep(for: .seconds(10)) }
        task.cancel()
        await #expect(throws: CancellationError.self) { try await task.value }
    }
}
