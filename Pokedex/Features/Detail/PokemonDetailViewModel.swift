import Observation
import PokeAPI

protocol DetailFetching {
    func fetchDetail(id: Int) async throws -> PokemonDetail
}

extension PokeAPIClient: DetailFetching {}

@Observable
final class PokemonDetailViewModel {
    private(set) var detail: PokemonDetail?
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    private let client: any DetailFetching
    
    init(client: any DetailFetching = PokeAPIClient()) {
        self.client = client
    }
    
    func load(id: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            detail = try await client.fetchDetail(id: id)
            errorMessage = nil
        } catch {
            if Task.isCancelled { return }
            errorMessage = "상세 정보를 불러오지 못했어요."
        }
    }
}
