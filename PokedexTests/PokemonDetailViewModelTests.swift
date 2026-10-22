import Foundation
import PokeAPI
import Testing

@testable import Pokedex

struct StubDetailFetcher: DetailFetching {
    var fails = false

    func fetchDetail(id: Int) async throws -> PokemonDetail {
        if fails {
            throw URLError(.notConnectedToInternet)
        }
        return PokemonDetail(id: id, heightInMeters: 0.4, weightInKilograms: 6)
    }
}

struct GatedDetailFetcher: DetailFetching {
    let gate: AsyncStream<Void>

    func fetchDetail(id: Int) async throws -> PokemonDetail {
        for await _ in gate { break }
        try Task.checkCancellation()
        return PokemonDetail(id: id, heightInMeters: 0.4, weightInKilograms: 6)
    }
}

@MainActor
struct PokemonDetailViewModelTests {
    @Test("상세 정보를 불러온다")
    func loads() async {
        let viewModel = PokemonDetailViewModel(client: StubDetailFetcher())
        await viewModel.load(id: 25)
        #expect(viewModel.detail?.id == 25)
        #expect(viewModel.errorMessage == nil)
        #expect(!viewModel.isLoading)
    }

    @Test("불러오지 못하면 에러 메시지를 보여준다")
    func failure() async {
        let viewModel = PokemonDetailViewModel(client: StubDetailFetcher(fails: true))
        await viewModel.load(id: 25)
        #expect(viewModel.detail == nil)
        #expect(viewModel.errorMessage != nil)
    }

    @Test("불러오는 동안에는 isLoading이 true다", .timeLimit(.minutes(1)))
    func loadingState() async {
        let (gate, open) = AsyncStream.makeStream(of: Void.self)
        let viewModel = PokemonDetailViewModel(client: GatedDetailFetcher(gate: gate))

        let task = Task { await viewModel.load(id: 25) }
        while !viewModel.isLoading { await Task.yield() }
        #expect(viewModel.detail == nil)

        open.yield()
        await task.value
        #expect(!viewModel.isLoading)
        #expect(viewModel.detail?.id == 25)
    }

    @Test("화면을 떠나 취소되면 에러를 보여주지 않는다", .timeLimit(.minutes(1)))
    func cancelled() async {
        let (gate, open) = AsyncStream.makeStream(of: Void.self)
        let viewModel = PokemonDetailViewModel(client: GatedDetailFetcher(gate: gate))

        let task = Task { await viewModel.load(id: 25) }
        while !viewModel.isLoading { await Task.yield() }
        task.cancel()
        await task.value

        #expect(viewModel.errorMessage == nil)
        #expect(!viewModel.isLoading)
        open.finish()
    }
}
