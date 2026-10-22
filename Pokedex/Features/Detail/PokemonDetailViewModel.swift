import OSLog
import Observation
import PokeAPI

private let logger = Logger(
    subsystem: "com.seosh817.Pokedex",
    category: "Detail"
)

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
            logger.debug("상세 정보 불러옴 id=\(id)")
        } catch {
            if Task.isCancelled {
                logger.debug("상세 정보 불러오기 취소 id=\(id)")
                return
            }
            logger.error(
                "상세 정보 불러오기 실패 id=\(id): \(error.localizedDescription, privacy: .public)"
            )
            errorMessage = "상세 정보를 불러오지 못했어요."
        }
    }
}
