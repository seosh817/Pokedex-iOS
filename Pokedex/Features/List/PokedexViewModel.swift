import Observation
import OSLog
import PokeAPI

protocol SummaryFetching {
    func fetchSummaries(ids: [Int]) async throws -> [PokemonSummary]
}

extension PokeAPIClient: SummaryFetching {}

@Observable
final class PokedexViewModel {
    private(set) var summaries: [PokemonSummary] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    var searchText = ""
    private(set) var numberResult: PokemonSummary?
    private(set) var isLookingUpNumber = false
    
    private let client: any SummaryFetching
    private let pageSize: Int
    private let maxID: Int
    
    init(client: any SummaryFetching = PokeAPIClient(), pageSize: Int = 20, maxID: Int = 1025) {
        self.client = client
        self.pageSize = pageSize
        self.maxID = maxID
    }
    
    var hasMore: Bool {
        summaries.count < maxID
    }

    var isSearching: Bool {
        !query.isEmpty
    }

    var searchResults: [PokemonSummary] {
        guard isSearching else { return summaries }
        let number = Self.number(from: query)
        var results = summaries.filter {
            $0.koreanName.contains(query)
                || $0.name.localizedCaseInsensitiveContains(query)
                || $0.id == number
        }
        if let numberResult, !results.contains(numberResult) {
            results.insert(numberResult, at: 0)
        }
        return results
    }

    private var query: String {
        searchText.trimmingCharacters(in: .whitespaces)
    }
    
    func loadFirstPageIfNeeded() async {
        guard summaries.isEmpty else { return }
        await loadNextPage()
    }
    
    func loadNextPage() async {
        guard !isLoading, hasMore else { return }
        isLoading = true
        defer { isLoading = false }
        
        let start = summaries.count + 1
        let end = min(start + pageSize - 1, maxID)
        do {
            let page = try await client.fetchSummaries(ids: Array(start...end))
            summaries.append(contentsOf: page)
            errorMessage = nil
            Logger.list.debug("페이지 불러옴 \(start)...\(end)")
        } catch {
            Logger.list.error("페이지 불러오기 실패 \(start)...\(end): \(error.localizedDescription, privacy: .public)")
            errorMessage = "포켓몬을 불러오지 못했어요. 인터넷 연결을 확인해 주세요."
        }
    }
    
    func search() async {
        numberResult = nil
        isLookingUpNumber = false
        guard let id = Self.number(from: query), (1...maxID).contains(id),
              !summaries.contains(where: { $0.id == id })
        else { return }

        isLookingUpNumber = true
        defer {
            if !Task.isCancelled { isLookingUpNumber = false }
        }

        try? await Task.sleep(for: .milliseconds(300))
        if Task.isCancelled { return }

        do {
            let summary = try await client.fetchSummaries(ids: [id]).first
            if Task.isCancelled { return }
            numberResult = summary
            Logger.list.debug("번호 검색 \(id)")
        } catch {
            if Task.isCancelled { return }
            Logger.list.error("번호 검색 실패 \(id): \(error.localizedDescription, privacy: .public)")
        }
    }

    static func number(from text: String) -> Int? {
        Int(text.hasPrefix("#") ? String(text.dropFirst()) : text)
    }

    func refresh() async {
        summaries = []
        errorMessage = nil
        await loadNextPage()
    }
}
