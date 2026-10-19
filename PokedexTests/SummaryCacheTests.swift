import Testing

@testable import Pokedex

@MainActor
struct SummaryCacheTests {
    let cache: SummaryCache
    let client: PokeAPIClient

    init() {
        cache = SummaryCache()
        client = PokeAPIClient(summaryCache: cache)
    }

    @Test("같은 포켓몬을 두 번 요청하면 한 번만 불러온다")
    func cachedOnSecondCall() async throws {
        _ = try await client.fetchSummary(id: 25)
        _ = try await client.fetchSummary(id: 25)
        let loadCount = await cache.loadCount
        #expect(loadCount == 1)
    }

    @Test("같은 포켓몬을 동시에 요청해도 한 번만 불러온다")
    func dedupesConcurrentCalls() async throws {
        let summaries = try await client.fetchSummaries(ids: [25, 25, 25, 25])
        #expect(summaries.count == 4)
        let loadCount = await cache.loadCount
        #expect(loadCount == 1)
    }
}
