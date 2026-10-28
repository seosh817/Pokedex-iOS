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
final class CountingSummaryFetcher: SummaryFetching {
    private(set) var requestedIDs: [[Int]] = []

    func fetchSummaries(ids: [Int]) async throws -> [PokemonSummary] {
        requestedIDs.append(ids)
        return try await StubSummaryFetcher().fetchSummaries(ids: ids)
    }
}

@MainActor
final class SlowSummaryFetcher: SummaryFetching {
    private(set) var isFetching = false

    func fetchSummaries(ids: [Int]) async throws -> [PokemonSummary] {
        isFetching = true
        // 취소돼도 에러 없이 결과를 돌려준다 (응답이 이미 오고 있던 경우)
        try? await Task.sleep(for: .seconds(10))
        return try await StubSummaryFetcher().fetchSummaries(ids: ids)
    }
}

@MainActor
extension PokemonNameIndex {
    static let stub = PokemonNameIndex(names: (1...5).map {
        PokemonName(id: $0, name: "pokemon\($0)", koreanName: "포켓몬\($0)")
    })
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

    @Test("불러온 목록에서 이름으로 찾는다", arguments: [
        ("포켓몬2", [2]),
        ("POKEMON1", [1]),
        ("없는 이름", []),
    ])
    func searchByName(query: String, expected: [Int]) async {
        let model = PokedexViewModel(client: StubSummaryFetcher(), nameIndex: .stub, pageSize: 3, maxID: 5)
        await model.loadFirstPageIfNeeded()
        model.searchText = query
        #expect(model.searchResults.map(\.id) == expected)
    }

    @Test("아직 불러오지 않은 번호는 바로 불러와서 보여준다")
    func searchByNumberNotLoaded() async {
        let model = PokedexViewModel(client: StubSummaryFetcher(), nameIndex: .stub, pageSize: 3, maxID: 5)
        await model.loadFirstPageIfNeeded()
        model.searchText = "#5"
        await model.search()
        #expect(model.searchResults.map(\.id) == [5])
    }

    @Test("아직 불러오지 않은 포켓몬도 이름으로 찾는다")
    func searchByNameNotLoaded() async {
        let fetcher = CountingSummaryFetcher()
        let model = PokedexViewModel(client: fetcher, nameIndex: .stub, pageSize: 3, maxID: 5)
        await model.loadFirstPageIfNeeded()
        model.searchText = "포켓몬"
        await model.search()
        #expect(model.searchResults.map(\.id) == [1, 2, 3, 4, 5])
        #expect(fetcher.requestedIDs == [[1, 2, 3], [4, 5]])
    }

    @Test("검색 결과가 많으면 끝에 닿을 때 더 불러온다")
    func loadMoreSearchResults() async {
        let fetcher = CountingSummaryFetcher()
        let model = PokedexViewModel(client: fetcher, nameIndex: .stub, pageSize: 2, maxID: 5)
        await model.loadFirstPageIfNeeded()
        model.searchText = "포켓몬"
        await model.search()
        #expect(model.searchResults.map(\.id) == [1, 2, 3, 4])

        await model.loadMoreSearchResults()
        #expect(model.searchResults.map(\.id) == [1, 2, 3, 4, 5])
        #expect(fetcher.requestedIDs == [[1, 2], [3, 4], [5]])
    }

    @Test("이미 불러온 번호는 다시 요청하지 않는다")
    func searchByNumberLoaded() async {
        let fetcher = CountingSummaryFetcher()
        let model = PokedexViewModel(client: fetcher, nameIndex: .stub, pageSize: 3, maxID: 5)
        await model.loadFirstPageIfNeeded()
        model.searchText = "2"
        await model.search()
        #expect(model.searchResults.map(\.id) == [2])
        #expect(fetcher.requestedIDs == [[1, 2, 3]])
    }

    @Test("검색어가 바뀌어 취소된 검색은 요청하지 않는다")
    func cancelledSearchDoesNotFetch() async {
        let fetcher = CountingSummaryFetcher()
        let model = PokedexViewModel(client: fetcher, nameIndex: .stub, pageSize: 3, maxID: 5)
        await model.loadFirstPageIfNeeded()

        model.searchText = "4"
        let first = Task { await model.search() }
        first.cancel()
        await first.value

        model.searchText = "5"
        await model.search()

        #expect(fetcher.requestedIDs == [[1, 2, 3], [5]])
        #expect(model.searchResults.map(\.id) == [5])
    }

    @Test("취소된 검색의 응답이 늦게 오면 지금 검색어에 맞을 때만 보인다", .timeLimit(.minutes(1)))
    func lateResponseAfterCancel() async {
        let fetcher = SlowSummaryFetcher()
        let model = PokedexViewModel(client: fetcher, nameIndex: .stub, pageSize: 3, maxID: 5)

        model.searchText = "4"
        let first = Task { await model.search() }
        while !fetcher.isFetching { await Task.yield() }
        first.cancel()

        model.searchText = "없는 이름"
        await model.search()
        await first.value
        #expect(model.searchResults.isEmpty)

        model.searchText = "4"
        #expect(model.searchResults.map(\.id) == [4])
    }

    @Test("검색 결과를 불러오는 동안에는 isFetchingSearchResults가 true다", .timeLimit(.minutes(1)))
    func fetchingSearchResultsState() async {
        let model = PokedexViewModel(client: StubSummaryFetcher(), nameIndex: .stub, pageSize: 3, maxID: 5)
        await model.loadFirstPageIfNeeded()
        model.searchText = "5"

        let task = Task { await model.search() }
        while !model.isFetchingSearchResults { await Task.yield() }
        #expect(model.searchResults.isEmpty)

        await task.value
        #expect(!model.isFetchingSearchResults)
        #expect(model.searchResults.map(\.id) == [5])
    }
}
