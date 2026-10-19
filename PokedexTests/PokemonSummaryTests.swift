import Foundation
import Testing

@testable import Pokedex

@MainActor
struct PokemonSummaryTests {
    let client = PokeAPIClient()
    
    @Test("상세와 종 정보를 합쳐 한국어 이름을 만든다")
    func koreanName() async throws {
        let pikachu = try await client.fetchSummary(id: 25)
        #expect(pikachu.koreanName == "피카츄")
        #expect(pikachu.types == ["electric"])
    }
    
    @Test("동시에 불러와도 결과는 id 순서다")
    func sortedById() async throws {
        let summaries = try await client.fetchSummaries(ids: [25, 1, 4, 7])
        #expect(summaries.map(\.koreanName) == ["이상해씨", "파이리", "꼬부기", "피카츄"])
    }
    
    @Test("하나라도 실패하면 전체가 실패한다")
    func oneFailureFailsAll() async {
        await #expect(throws: URLError.self) {
            try await client.fetchSummaries(ids: [1, 2, 99999])
        }
    }
    
    @Test("동시에 불러오면 하나씩 불러올 때보다 빠르다")
    func parallelIsFaster() async throws {
        let client = PokeAPIClient(session: URLSession(configuration: .ephemeral))
        let clock = ContinuousClock()
        let serial = try await clock.measure {
            for id in 1...10 {
                _ = try await client.fetchSummary(id: id)
            }
        }
        let parallel = try await clock.measure {
            _ = try await client.fetchSummaries(ids: Array(11...20))
        }
        print("하나씩: \(serial), 동시에: \(parallel)")
        #expect(parallel < serial)
    }
}
