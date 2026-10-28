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
    private(set) var isFetchingSearchResults = false
    private var searchCache: [Int: PokemonSummary] = [:]
    
    private let client: any SummaryFetching
    private let nameIndex: PokemonNameIndex
    private let pageSize: Int
    private let maxID: Int
    
    init(
        client: any SummaryFetching = PokeAPIClient(),
        nameIndex: PokemonNameIndex = .bundled,
        pageSize: Int = 20,
        maxID: Int = 1025
    ) {
        self.client = client
        self.nameIndex = nameIndex
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
        let loaded = Dictionary(summaries.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        return nameIndex.ids(matching: query).compactMap { loaded[$0] ?? searchCache[$0] }
    }

    private var missingSearchIDs: [Int] {
        guard isSearching else { return [] }
        let loaded = Set(summaries.map(\.id))
        return nameIndex.ids(matching: query).filter { !loaded.contains($0) && searchCache[$0] == nil }
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
        isFetchingSearchResults = !missingSearchIDs.isEmpty
        guard isFetchingSearchResults else { return }

        try? await Task.sleep(for: .milliseconds(300))
        if Task.isCancelled { return }
        await fetchSearchResults()
    }

    func loadMoreSearchResults() async {
        guard !isFetchingSearchResults else { return }
        await fetchSearchResults()
    }

    private func fetchSearchResults() async {
        let ids = Array(missingSearchIDs.prefix(pageSize))
        guard !ids.isEmpty else {
            isFetchingSearchResults = false
            return
        }

        isFetchingSearchResults = true
        defer {
            if !Task.isCancelled { isFetchingSearchResults = false }
        }

        do {
            for summary in try await client.fetchSummaries(ids: ids) {
                searchCache[summary.id] = summary
            }
            Logger.list.debug("검색 결과 \(ids.count)마리 불러옴")
        } catch {
            if Task.isCancelled { return }
            Logger.list.error("검색 결과 불러오기 실패: \(error.localizedDescription, privacy: .public)")
        }
    }

    func refresh() async {
        summaries = []
        errorMessage = nil
        await loadNextPage()
    }
}
