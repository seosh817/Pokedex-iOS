import Foundation
import Testing
import PokeAPI

@testable import Pokedex

struct StubSummaryFetcher: SummaryFetching {
    var fails = false

    func fetchSummaries(ids: [Int]) async throws -> [PokemonSummary] {
        if fails {
            throw URLError(.notConnectedToInternet)
        }
        return ids.map {
            PokemonSummary(
                id: $0,
                name: "pokemon\($0)",
                koreanName: "포켓몬\($0)",
                types: []
            )
        }
    }
}

@MainActor
struct PokedexViewModelTests {
    @Test("첫 페이지를 불러온다")
    func firstPage() async {
        let model = PokedexViewModel(client: StubSummaryFetcher(), pageSize: 3, maxID: 5)
        await model.loadFirstPageIfNeeded()
        #expect(model.summaries.map(\.id) == [1, 2, 3])
        #expect(model.hasMore)
    }

    @Test("다음 페이지를 이어 붙이고, 끝에 닿으면 더 부르지 않는다")
    func nextPagesUntilEnd() async {
        let model = PokedexViewModel(client: StubSummaryFetcher(), pageSize: 3, maxID: 5)
        await model.loadNextPage()
        await model.loadNextPage()
        #expect(model.summaries.map(\.id) == [1, 2, 3, 4, 5])
        #expect(!model.hasMore)

        await model.loadNextPage()
        #expect(model.summaries.count == 5)
    }

    @Test("새로고침하면 첫 페이지부터 다시 불러온다")
    func refresh() async {
        let model = PokedexViewModel(client: StubSummaryFetcher(), pageSize: 3, maxID: 5)
        await model.loadNextPage()
        await model.loadNextPage()
        await model.refresh()
        #expect(model.summaries.map(\.id) == [1, 2, 3])
    }
    
    @Test("불러오지 못하면 에러 메시지를 보여준다")
    func failure() async {
        let model = PokedexViewModel(client: StubSummaryFetcher(fails: true), pageSize: 3, maxID: 5)
        await model.loadFirstPageIfNeeded()
        #expect(model.summaries.isEmpty)
        #expect(model.errorMessage != nil)
        #expect(!model.isLoading)
    }
}
