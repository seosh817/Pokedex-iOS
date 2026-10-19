import Testing

@testable import Pokedex

@MainActor
struct SummaryPagesTests {
    let cache: SummaryCache
    let client: PokeAPIClient
    
    init() {
        cache = SummaryCache()
        client = PokeAPIClient(summaryCache: cache)
    }
    
    @Test("페이지 단위로 차례대로 받는다")
    func pagesInOrder() async throws {
        var pages: [[Int]] = []
        for try await page in client.summaryPages(ids: Array(1...10), pageSize: 4) {
            pages.append(page.map(\.id))
        }
        #expect(pages == [[1,2,3,4], [5, 6, 7, 8], [9, 10]])
    }
}
