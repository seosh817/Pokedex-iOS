import Testing

@testable import Pokedex

@MainActor
struct PokedexViewModelTests {
    @Test("첫 페이지를 불러온다")
    func firstPage() async {
        let model = PokedexViewModel(pageSize: 3, maxID: 5)
        await model.loadFirstPageIfNeeded()
        #expect(model.summaries.map(\.id) == [1, 2, 3])
        #expect(model.hasMore)
    }
    
    @Test("다음 페이지를 이어 붙이고, 끝에 닿으면 더 부르지 않는다")
    func nextPagesUntilEnd() async {
        let model = PokedexViewModel(pageSize: 3, maxID: 5)
        await model.loadNextPage()
        await model.loadNextPage()
        #expect(model.summaries.map(\.id) == [1, 2, 3, 4, 5])
        #expect(!model.hasMore)
        
        await model.loadNextPage()
        #expect(model.summaries.count == 5)
    }
    
    @Test("새로고침하면 첫 페이지부터 다시 불러온다")
    func refresh() async {
        let model = PokedexViewModel(pageSize: 3, maxID: 5)
        await model.loadNextPage()
        await model.loadNextPage()
        await model.refresh()
        #expect(model.summaries.map(\.id) == [1, 2, 3])
    }
}
